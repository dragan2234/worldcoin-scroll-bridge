use sqlx::{Postgres, Transaction};
use tracing::instrument;

use crate::database::query::DatabaseQuery;
use crate::database::{Database, Error};
use crate::processor::status::BridgeStatus;
use crate::retry_tx;

pub async fn mark_status_as_pending(
    tx: &mut Transaction<'_, Postgres>,
) -> Result<(), Error> {
    let status = BridgeStatus::Pending;
    tx.update_server_status(status).await?;
    Ok(())
}

pub async fn mark_status_as_unsynced(
    tx: &mut Transaction<'_, Postgres>,
) -> Result<(), Error> {
    let status = BridgeStatus::Unsynced;
    tx.update_server_status(status).await?;
    Ok(())
}

pub async fn mark_status_as_synced(
    tx: &mut Transaction<'_, Postgres>,
) -> Result<(), Error> {
    let status = BridgeStatus::Synced;
    tx.update_server_status(status).await?;
    Ok(())
}

/// impl block for database transactions
impl Database {
    /// marks server status as pending
    #[instrument(skip(self), level = "debug")]
    pub async fn mark_status_as_pending(&self) -> Result<(), Error> {
        retry_tx!(self.pool, tx, mark_status_as_pending(&mut tx).await).await
    }

    ///  marks server status as synced and updates last synced time
    #[instrument(skip(self), level = "debug")]
    pub async fn mark_status_as_synced(&self) -> Result<(), Error> {
        retry_tx!(self.pool, tx, mark_status_as_synced(&mut tx).await).await
    }

    /// marks following server as unsynced
    #[instrument(skip(self), level = "debug")]
    pub async fn mark_status_as_unsynced(&self) -> Result<(), Error> {
        retry_tx!(self.pool, tx, mark_status_as_unsynced(&mut tx).await).await
    }   
}
