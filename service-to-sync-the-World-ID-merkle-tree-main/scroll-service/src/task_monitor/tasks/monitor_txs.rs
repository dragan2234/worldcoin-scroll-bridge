use std::sync::Arc;

use tokio::sync::{mpsc, Mutex};
use tracing::{error, info};

use crate::app::App;
use crate::database::query::DatabaseQuery;
use crate::database::types::TxStatus;
use crate::utils::TransactionId;

pub async fn monitor_txs(
    app: Arc<App>,
    monitored_txs_receiver: Arc<Mutex<mpsc::Receiver<TransactionId>>>,
) -> anyhow::Result<()> {
    let mut monitored_txs_receiver = monitored_txs_receiver.lock().await;

    while let Some(tx) = monitored_txs_receiver.recv().await {
        // assert!(
        match app.bridge_processor.mine_transaction(tx.clone()).await  {
            Ok(id) => {
                info!("Transaction Status: {:?}", id);
                app.database.update_transaction(&tx, TxStatus::Mined).await?;
            },
            Err(err) => {
                error!(%err, "Transaction failed");
                app.database.update_transaction(&tx, TxStatus::Mined).await?;
            }
        };
    }

    Ok(())
}
