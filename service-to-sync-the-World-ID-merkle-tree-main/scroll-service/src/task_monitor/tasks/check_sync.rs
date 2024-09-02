use std::sync::Arc;
use std::time::Duration;

use crate::database::types::TxStatus;
use crate::processor::status::BridgeStatus;
use crate::task_monitor::{App, TaskMonitor};
use tokio::sync::Notify;
use tokio::time;
use tracing::info;

pub async fn check_sync(app: Arc<App>, wake_up_notify: Arc<Notify>) -> anyhow::Result<()> {
    let mut timer = time::interval(Duration::from_secs(120));
    loop {
        _ = timer.tick().await;
        info!("Sync processor woken due to timeout.");

        let is_synced = TaskMonitor::check_synced_state(&app).await?;

        let tx_pending = TaskMonitor::check_last_transaction_status(&app.database, TxStatus::Pending).await?;

        let db_state_pending = TaskMonitor::check_db_state(&app.database, BridgeStatus::Pending).await?;

        info!(?is_synced, ?tx_pending, ?db_state_pending);

        // if still synced or pending continue so as not to call the propagate
        if is_synced && db_state_pending {
          app.database.mark_status_as_synced().await?;
          continue;
        } else if is_synced || (tx_pending && db_state_pending) {
          continue;
        }

        app.database.mark_status_as_unsynced().await?;

        wake_up_notify.notify_one()
    }
}
