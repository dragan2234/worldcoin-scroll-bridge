use std::sync::Arc;

use anyhow::bail;
use ethers::types::transaction::eip2718::TypedTransaction;
use ethers::types::Address;
pub use read::ReadProvider;
use tracing::instrument;
pub use write::TxError;

use self::write_provider::WriteProvider;
use crate::config::Config;
pub type TransactionId = String;

pub mod read;
pub mod write;

mod write_provider;

#[derive(Clone, Debug)]
pub struct Ethereum {
    l1_read_provider:   Arc<ReadProvider>,
    l1_write_provider:  Arc<WriteProvider>,
    l2_read_provider:   Arc<ReadProvider>,
}

impl Ethereum {
    #[instrument(name = "Ethereum::new", level = "debug", skip_all)]
    pub async fn new(config: &Config) -> anyhow::Result<Self> {
        let Some(providers_config) = &config.providers else {
            bail!("Providers config is required for Ethereum.");
        };

        let Some(relayer_config) = &config.relayer else {
            bail!("Relayer config is required for Ethereum.");
        };

        let l1_read_provider =
            ReadProvider::new(providers_config.l1_network_provider.clone().into()).await?;

        let l2_read_provider = ReadProvider::new(providers_config.l2_network_provider.clone().into()).await?;

        let l1_write_provider: Arc<WriteProvider> =
            Arc::new(WriteProvider::new(l1_read_provider.clone(), relayer_config).await?);

        Ok(Self {
            l1_read_provider: Arc::new(l1_read_provider),
            l2_read_provider: Arc::new(l2_read_provider),
            l1_write_provider,
        })
    }

    #[must_use]
    pub const fn l1_provider(&self) -> &Arc<ReadProvider> {
        &self.l1_read_provider
    }

    #[must_use]
    pub const fn l2_provider(&self) -> &Arc<ReadProvider>{
        &self.l2_read_provider
    }

    #[must_use]
    pub fn address(&self) -> Address {
        self.l1_write_provider.address()
    }

    pub async fn send_transaction(
        &self,
        tx: TypedTransaction,
        only_once: bool,
    ) -> Result<TransactionId, TxError> {
        tracing::info!(?tx, "Sending transaction");
        self.l1_write_provider.send_transaction(tx, only_once).await
    }

    pub async fn fetch_pending_transactions(&self) -> Result<Vec<TransactionId>, TxError> {
        self.l1_write_provider.fetch_pending_transactions().await
    }

    pub async fn fetch_mined_transactions(&self) -> Result<Vec<TransactionId>, TxError> {
        self.l1_write_provider.fetch_mined_transactions().await
    }

    pub async fn mine_transaction(&self, tx: TransactionId) -> Result<bool, TxError> {
        self.l1_write_provider.mine_transaction(tx).await
    }
}
