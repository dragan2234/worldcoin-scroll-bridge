use std::str::FromStr;
use std::sync::Arc;
use std::time::Duration;

use once_cell::sync::Lazy;
use prometheus::{ register_gauge, Gauge};

use tokio::sync::{broadcast, mpsc, Mutex, RwLock, Notify};
use tokio::task::JoinHandle;
use tracing::{info, instrument, warn};
use crate::database::query::DatabaseQuery;
use crate::database::types::TxStatus;
use crate::database::Database;
use crate::processor::status::BridgeStatus;
use crate::utils::shutdown::Shutdown;
use crate::app::App;

pub mod tasks;

const PROPAGATE_ROOT_BACKOFF: Duration = Duration::from_secs(5);
const CHECK_SYNC_STATE_BACKOFF: Duration = Duration::from_secs(5);
const MONITOR_TXNS_BACKOFF: Duration = Duration::from_secs(5);
const FINALIZE_TXNS_BACKOFF: Duration = Duration::from_secs(5);

struct RunningInstance {
    handles:         Vec<JoinHandle<()>>,
    shutdown_sender: broadcast::Sender<()>,
}

static SYNCED_STATE: Lazy<Gauge> = Lazy::new(|| {
    register_gauge!("synced_state", "current scroll bridge sync status").unwrap()
});

impl RunningInstance {
    async fn shutdown(self) -> anyhow::Result<()> {
        info!("Sending a shutdown signal to the service.");
        // Ignoring errors here, since we have two options: either the channel is full,
        // which is impossible, since this is the only use, and this method takes
        // ownership, or the channel is closed, which means the committer thread is
        // already dead.
        _ = self.shutdown_sender.send(());

        info!("Awaiting tasks to shutdown.");
        for result in futures::future::join_all(self.handles).await {
            result?;
        }

        Ok(())
    }
}

/// A worker that commits identities to the blockchain.
///
/// This uses the database to keep track of identities that need to be
/// committed. It assumes that there's only one such worker spawned at
/// a time. Spawning multiple worker threads will result in undefined behavior,
/// including data duplication.
pub struct TaskMonitor {
    /// The instance is kept behind an RwLock<Option<...>> because
    /// when shutdown is called we want to be able to gracefully
    /// await the join handles - which requires ownership of the handle and by
    /// extension the instance.
    instance: RwLock<Option<RunningInstance>>,
    shutdown: Arc<Shutdown>,
    app:      Arc<App>,
}

impl TaskMonitor {
    pub fn new(app: Arc<App>, shutdown: Arc<Shutdown>) -> Self {
        Self {
            instance: RwLock::new(None),
            shutdown,
            app,
        }
    }

    #[instrument(level = "debug", skip_all)]
    pub async fn start(&self) {
        let mut instance = self.instance.write().await;
        if instance.is_some() {
            warn!("Scroll service already running");
        }

        // We could use the second element of the tuple as `mut shutdown_receiver`,
        // but for symmetry's sake we create it for every task with `.subscribe()`
        let (shutdown_sender, _) = broadcast::channel(1);

        let (monitored_txs_sender, monitored_txs_receiver) =
            mpsc::channel(self.app.config.app.monitored_txs_capacity);

        let monitored_txs_sender = Arc::new(monitored_txs_sender);
        let monitored_txs_receiver = Arc::new(Mutex::new(monitored_txs_receiver));


        let mut handles = Vec::new();

        let base_wake_up_notify = Arc::new(Notify::new());
        
        // Propagate Root
        let app = self.app.clone();
        let wake_up_notify = base_wake_up_notify.clone();
        let propagate_root = move || {
            tasks::propagate_root::propagate_root(
                app.clone(),
                monitored_txs_sender.clone(),
                wake_up_notify.clone()
            )
        };
        let propagate_root_handle = crate::utils::spawn_monitored_with_backoff(
            propagate_root,
            shutdown_sender.clone(),
            PROPAGATE_ROOT_BACKOFF,
            self.shutdown.clone(),
        );
        handles.push(propagate_root_handle);
      
        // Check Status
        let app = self.app.clone();
        let wake_up_notify = base_wake_up_notify.clone();
        let check_sync_state = move || {
            tasks::check_sync::check_sync(
                app.clone(),
                wake_up_notify.clone()
            )
        };

        let check_sync_state_handle = crate::utils::spawn_monitored_with_backoff(
            check_sync_state,
            shutdown_sender.clone(),
            CHECK_SYNC_STATE_BACKOFF,
            self.shutdown.clone(),
        );
        handles.push(check_sync_state_handle);

        
        // Finalize transactions
        let app = self.app.clone();
        let finalize_txs =
            move || tasks::finalize_txs::finalize_txs(app.clone());
        let finalize_txs_handle = crate::utils::spawn_monitored_with_backoff(
            finalize_txs,
            shutdown_sender.clone(),
            FINALIZE_TXNS_BACKOFF,
            self.shutdown.clone(),
        );
        handles.push(finalize_txs_handle);

        // Monitor transactions
        let app = self.app.clone();
        let monitor_txs =
            move || tasks::monitor_txs::monitor_txs(app.clone(), monitored_txs_receiver.clone());
        let monitor_txs_handle = crate::utils::spawn_monitored_with_backoff(
            monitor_txs,
            shutdown_sender.clone(),
            MONITOR_TXNS_BACKOFF,
            self.shutdown.clone(),
        );
        handles.push(monitor_txs_handle);

        // Create the instance
        *instance = Some(RunningInstance {
            handles,
            shutdown_sender,
        });
    }

    async fn check_synced_state(app: &Arc<App>) -> anyhow::Result<bool> {
        let state = app.bridge_processor.check_sync_state().await?;
        let gauge_value = if state { 1.0 } else { 0.0 };
        SYNCED_STATE.set(gauge_value);
        Ok(state)
    }

    async fn check_db_state(database: &Database, status_check: BridgeStatus) -> anyhow::Result<bool> {
        let status = database.get_db_status().await?.unwrap_or_else(|| "unsynced".to_string());
        let bridge_status = BridgeStatus::from_str(&status).unwrap_or(BridgeStatus::Unsynced);
        Ok(bridge_status == status_check)
    }

    async fn check_last_transaction_status(database: &Database, status_check: TxStatus) -> anyhow::Result<bool> {
        let status = database.get_last_transaction_status().await?;
        // let tx_status = TxStatus::from_str(&status).unwrap_or(TxStatus::Pending);
        Ok(status == Some(status_check))
    }

    /// # Errors
    ///
    /// Will return an Error if the committer thread cannot be shut down
    /// gracefully.
    pub async fn shutdown(&self) -> anyhow::Result<()> {
        let mut instance = self.instance.write().await;
        if let Some(instance) = instance.take() {
            instance.shutdown().await?;
        } else {
            info!("Committer not running.");
        }
        Ok(())
    }
}
