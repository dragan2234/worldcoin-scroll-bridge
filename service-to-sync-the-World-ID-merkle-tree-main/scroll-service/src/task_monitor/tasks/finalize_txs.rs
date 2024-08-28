use std::sync::Arc;
use tracing::{error, info};
use tokio::time;
use std::time::Duration;

use crate::database::types::TxStatus;
use crate::{app::App, database::query::DatabaseQuery};

pub async fn finalize_txs(
    app: Arc<App>
) -> anyhow::Result<()> {
  let mut timer = time::interval(Duration::from_secs(600));
  loop {
    _ = timer.tick().await;
    let mined_transactions = app.bridge_processor.get_mined_transactions().await?;    

    match app.database.get_last_transaction_id().await {
      Ok(Some(id)) => { 
        info!("Pending Transaction found: {:?}", id);
        if mined_transactions.contains(&id) {
          app.database.update_transaction(&id, TxStatus::Mined).await?;
          info!("Transaction ID found in mined transactions: {:?}", id);
        }
      },
      Ok(None) => {
          info!("No Pending Transaction");
      }
      Err(err) => {
          error!(%err, "Failed to retrieve the last transaction ID");
      }
    };
  }
}
