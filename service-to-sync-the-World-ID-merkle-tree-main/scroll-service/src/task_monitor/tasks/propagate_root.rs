use std::sync::Arc;
use tokio::sync::{mpsc, Notify};
use crate::database::query::DatabaseQuery;
use crate::database::types::TxStatus;
use crate::processor::status::BridgeStatus;
use crate::task_monitor::{App, TaskMonitor};
use crate::utils::TransactionId;
use tracing::error;

pub async fn propagate_root(
    app: Arc<App>, 
    monitored_txs_sender: Arc<mpsc::Sender<TransactionId>>,
    wake_up_notify: Arc<Notify>
) -> anyhow::Result<()> {
    loop {
        _ = wake_up_notify.notified();

        let is_unsynced = TaskMonitor::check_db_state(&app.database, BridgeStatus::Unsynced).await?;

        // there is an existing tx pending
        let tx_pending = TaskMonitor::check_last_transaction_status(&app.database, TxStatus::Pending).await?;


        if !is_unsynced || tx_pending {
            continue;
        }
        
        let tx_id = app.bridge_processor
            .propagate_root()
            .await?;

        // add tx_id to db
        app.database.insert_new_transaction(&tx_id).await?;

        match monitored_txs_sender.send(tx_id.clone()).await {
            Ok(id) => {
                id
            },
            Err(err) => {
                error!(%err, "Transaction failed");
            }
        };

        // update db state to pending
        app.database.mark_status_as_pending().await?;
    }
}
