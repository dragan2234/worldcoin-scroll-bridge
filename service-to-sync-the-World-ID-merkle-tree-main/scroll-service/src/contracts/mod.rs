//! Functionality for interacting with smart contracts deployed on chain.
pub mod abi;

use anyhow::{anyhow, bail};
use ethers::providers::Middleware;
use ethers::types::U256;
use tracing::{error, info, instrument};

use self::abi::{ScrollStateBridge, ScrollWorldId, WorldId};
use crate::config::Config;
use crate::ethereum::{Ethereum, ReadProvider};
use crate::utils::TransactionId;

/// A structure representing the interface to the batch-based identity manager
/// contract.
#[derive(Debug)]
pub struct ScrollBridge {
    ethereum:       Ethereum,
    bridge_abi:            ScrollStateBridge<ReadProvider>,
    scroll_world_id_abi:  ScrollWorldId<ReadProvider>,
    world_id_abi:   WorldId<ReadProvider>
}

impl ScrollBridge {
    // TODO: I don't like these public getters
    pub fn bridge_abi(&self) -> &ScrollStateBridge<ReadProvider> {
        &self.bridge_abi
    }

    pub fn scroll_world_id_abi(&self) -> &ScrollWorldId<ReadProvider> {
        &self.scroll_world_id_abi
    }

    pub fn world_id_abi(&self) -> &WorldId<ReadProvider> {
      &self.world_id_abi
  }

    #[instrument(level = "debug", skip_all)]
    pub async fn new(config: &Config, ethereum: Ethereum) -> anyhow::Result<Self>
    where
        Self: Sized,
    {
        let Some(network_config) = &config.network else {
            bail!("Network config is required for ScrollBridge.");
        };

        // Check that there is code deployed at the target address.
        let address = network_config.scroll_bridge_address;
        let code = ethereum.l1_provider().get_code(address, None).await?;
        if code.as_ref().is_empty() {
            error!(
                ?address,
                "No contract code is deployed at the provided address."
            );
        }

        // Connect to the running batching contract.
        let bridge_abi = ScrollStateBridge::new(
            address,
            ethereum.l1_provider().clone(),
        );

        let owner = bridge_abi.owner().call().await?;
        // if owner != ethereum.address() {
        //     error!(?owner, signer = ?ethereum.address(), "Signer is not the owner of the state bridge contract.");
        //     panic!("Cannot currently continue in read-only mode.")
        // }

        info!(
            ?address,
            ?owner,
            "Connected to the Scroll State WorldID Bridge"
        );

        // get scrollworldID address from scoll bridge
        let scroll_world_id_address = bridge_abi.scroll_world_id_address().call().await?;
        info!(?scroll_world_id_address);

        let code = ethereum.l2_provider().get_code(scroll_world_id_address, None).await?;
        if code.as_ref().is_empty() {
            error!(
                ?scroll_world_id_address,
                "No contract code is deployed at the scroll world id address."
            );
            panic!("Cannot continue")
        }

        let scroll_world_id_abi = ScrollWorldId::new(
            scroll_world_id_address,
            ethereum.l2_provider().clone()
        );

        // get worldId address from scroll bridge
        let world_id_address = bridge_abi.world_id_address().call().await?;
        let code = ethereum.l1_provider().get_code(world_id_address, None).await?;
        if code.as_ref().is_empty() {
            error!(
                ?world_id_address,
                "No contract code is deployed at the scroll world id address."
            );
            panic!("Cannot continue");
        }
        let world_id_abi = WorldId::new(
            world_id_address,
            ethereum.l1_provider().clone()
        );

        let scroll_bridge = Self {
            ethereum,
            bridge_abi,
            scroll_world_id_abi,
            world_id_abi
        };

        Ok(scroll_bridge)
    }

    #[instrument(level = "debug")]
    pub async fn propagate_root(&self) -> anyhow::Result<TransactionId> {
        let mut propagate_root_transaction: ethers::types::transaction::eip2718::TypedTransaction  = self.bridge_abi.propagate_root().tx;
        let value_in_wei: U256 = ethers::utils::parse_ether("0.1").unwrap();
        propagate_root_transaction.set_value(value_in_wei);
        self.ethereum
            .send_transaction(propagate_root_transaction, true)
            .await
            .map_err(|tx_err| anyhow!("{}", tx_err.to_string()))
    }

    #[instrument(level = "debug", skip_all)]
    pub async fn get_scroll_latest_root(&self) -> anyhow::Result<U256> {
        let latest_root = self.scroll_world_id_abi.latest_root().call().await?;
        Ok(latest_root)
    }

    #[instrument(level = "debug", skip_all)]
    pub async fn get_world_id_latest_root(&self) -> anyhow::Result<U256> {
        let latest_root = self.world_id_abi.latest_root().call().await?;
        Ok(latest_root)
    }
    
    #[instrument(level = "debug", skip_all)]
    pub async fn check_sync_state(&self) -> anyhow::Result<bool>{
        let latest_root_scroll_world_id = match self.get_scroll_latest_root().await {
            Ok(id) => id,
            Err(err) => {
                // Log the error with context but do not panic
                error!(%err, "Failed to get the latest root world ID");
                // Return false or another appropriate value to indicate failure
                return Ok(false);
            }
        };

        let latest_root_world_id = self.get_world_id_latest_root().await?;
        // info!("latest_root_world_id: {:?}", latest_root_world_id);
        Ok(latest_root_scroll_world_id == latest_root_world_id)
    }
    
    #[instrument(level = "debug", skip_all)]
    pub async fn is_root_mined(&self, root: U256) -> anyhow::Result<bool> {
        let (root_on_mainnet, ..) = self.world_id_abi.query_root(root).call().await?;

        if root_on_mainnet.is_zero() {
            return Ok(false);
        }

        let root_timestamp = self.scroll_world_id_abi.root_history(root).call().await?;

        // root_history only returns superseded roots, so we must also check the latest
        // root
        let latest_root = self.scroll_world_id_abi.latest_root().call().await?;

        // If root is not superseded and it's not the latest root
        // then it's not mined
        if root_timestamp == 0 && root != latest_root {
            return Ok(false);
        }

        Ok(true)
    }
}
