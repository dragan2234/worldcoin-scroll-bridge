use std::str::FromStr;
use serde::{Deserialize, Serialize};
use thiserror::Error;

#[derive(
  Debug, Clone, Serialize, Deserialize, Copy, PartialEq, Eq, sqlx::Type
)]
#[sqlx(rename_all = "camelCase")]
#[sqlx(type_name = "tx_status")]
#[serde(rename_all = "camelCase")]
pub enum BridgeStatus {
    Unsynced,
    Pending,
    Synced,
}

#[derive(Debug, Error)]
#[error("unknown status")]
pub struct UnknownStatus;

impl FromStr for BridgeStatus {
    type Err = UnknownStatus;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s {
            "unsynced" => Ok(Self::Unsynced),
            "pending" => Ok(Self::Pending),
            "synced" => Ok(Self::Synced),
            _ => Err(UnknownStatus),
        }
    }
}

impl TryFrom<&str> for BridgeStatus {
  type Error = UnknownStatus;

  fn try_from(s: &str) -> Result<Self, Self::Error> {
    BridgeStatus::from_str(s)
  }
}

impl From<BridgeStatus> for &str {
  fn from(scope: BridgeStatus) -> Self {
      match scope {
        BridgeStatus::Pending => "pending",
        BridgeStatus::Unsynced => "unsynced",
        BridgeStatus::Synced => "Synced",
      }
  }
}
