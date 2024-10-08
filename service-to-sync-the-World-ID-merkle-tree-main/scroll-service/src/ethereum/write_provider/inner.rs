use ethers::types::transaction::eip2718::TypedTransaction;
use ethers::types::H256;

use crate::ethereum::TxError;
use crate::utils::TransactionId;

#[async_trait::async_trait]
pub trait Inner: Send + Sync + 'static {
    async fn send_transaction(
        &self,
        tx: TypedTransaction,
        only_once: bool,
    ) -> Result<TransactionId, TxError>;

    async fn fetch_pending_transactions(&self) -> Result<Vec<TransactionId>, TxError>;

    async fn mine_transaction(&self, tx: TransactionId) -> Result<TransactionResult, TxError>;

    async fn fetch_mined_transactions(&self) -> Result<Vec<TransactionId>, TxError>;
}

pub struct TransactionResult {
    pub transaction_id: String,
    pub hash:           Option<H256>,
}
