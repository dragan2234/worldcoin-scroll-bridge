use std::sync::Arc;

use async_trait::async_trait;

use tracing::{error, info, instrument};

pub mod status;

use crate::contracts::ScrollBridge;
use crate::ethereum::Ethereum;

pub type TransactionId = String;

#[async_trait]
pub trait Processor: Send + Sync + 'static {
    async fn propagate_root(&self) -> anyhow::Result<TransactionId>;
    async fn check_sync_state(&self) -> anyhow::Result<bool>;
    async fn get_mined_transactions(&self) -> anyhow::Result<Vec<TransactionId>>;
    async fn mine_transaction(&self, transaction_id: TransactionId) -> anyhow::Result<bool>;
}

pub struct BridgeProcessor {
    ethereum:           Ethereum,
    scroll_bridge:      Arc<ScrollBridge>
}

#[async_trait]
impl Processor for BridgeProcessor {
    async fn propagate_root(&self) -> anyhow::Result<TransactionId> {
        self.propagate_root().await
    }

    async fn check_sync_state(&self) -> anyhow::Result<bool> {
        self.check_sync_state().await
    }

    async fn get_mined_transactions(&self) -> anyhow::Result<Vec<TransactionId>>{
        // Await for all mined transactions
        let mined_transactions = self.fetch_mined_transactions().await?;
        Ok(mined_transactions)
    }

    #[instrument(level = "debug", skip(self))]
    async fn mine_transaction(&self, transaction_id: TransactionId) -> anyhow::Result<bool> {
        let result = self.ethereum.mine_transaction(transaction_id).await?;
        Ok(result)
    }
}

impl BridgeProcessor {
    pub async fn new(
        ethereum: Ethereum,
        scroll_bridge: Arc<ScrollBridge>
    ) -> anyhow::Result<Self> {
        Ok(Self {
            ethereum,
            scroll_bridge
        })
    }


    #[instrument(level = "info", skip_all)]
    async fn propagate_root(
        &self,
    ) -> anyhow::Result<TransactionId> {

        info!("Creating propagate root txn");

        let transaction_id = self
            .scroll_bridge
            .propagate_root()
            .await
            .map_err(|e| {
                error!(?e, "Failed to propagate root");
                e
            })?;

        info!(
            ?transaction_id,
            "Progation root txn submitted"
        );

        Ok(transaction_id)
    }

    async fn check_sync_state(
        &self,
    ) -> anyhow::Result<bool> {

        let result = self
            .scroll_bridge.check_sync_state()
            .await
            .map_err(|e| {
                error!(?e, "Failed to check sync");
                e
            })?;
        Ok(result)
    }

    #[instrument(level = "debug", skip_all)]
    async fn fetch_mined_transactions(&self) -> anyhow::Result<Vec<TransactionId>> {
        let pending_transactions = self.ethereum.fetch_mined_transactions().await?;
        Ok(pending_transactions)
    }

}

