use chrono::{DateTime, Utc};
use sqlx::prelude::FromRow;
use serde::{Deserialize, Serialize};
use std::str::FromStr;
use thiserror::Error;

#[derive(Debug, Clone, FromRow, Serialize, Deserialize, PartialEq)]
#[serde(rename_all = "camelCase")]
pub struct ServerStatus {
    pub status: String,
    pub last_synced: Option<DateTime<Utc>>,
}


#[derive(
    Debug, Clone, Serialize, Deserialize, Copy, PartialEq, Eq, sqlx::Type
)]
#[sqlx(rename_all = "camelCase")]
#[sqlx(type_name = "tx_status")]
#[serde(rename_all = "camelCase")]
pub enum TxStatus {
    Pending,
    Mined,
    Finalized,
    Failed
}

#[derive(Debug, Error)]
#[error("unknown status")]
pub struct UnknownStatus;

impl FromStr for TxStatus {
    type Err = UnknownStatus;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s {
            "failed" => Ok(Self::Failed),
            "pending" => Ok(Self::Pending),
            "mined" => Ok(Self::Mined),
            "finalized" => Ok(Self::Finalized),
            _ => Err(UnknownStatus),
        }
    }
}

impl TryFrom<&str> for TxStatus {
  type Error = UnknownStatus;

  fn try_from(s: &str) -> Result<Self, Self::Error> {
    TxStatus::from_str(s)
  }
}

impl From<TxStatus> for &str {
  fn from(scope: TxStatus) -> Self {
      match scope {
        TxStatus::Pending => "pending",
        TxStatus::Mined => "mined",
        TxStatus::Finalized => "finalized",
        TxStatus::Failed => "failed"
      }
  }
}
