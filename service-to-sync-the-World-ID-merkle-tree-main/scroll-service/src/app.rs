use std::sync::Arc;

use tracing::{info, instrument};
use crate::config::Config;
use crate::contracts::ScrollBridge;
use crate::database::Database;
use crate::database::query::DatabaseQuery;
use crate::processor::{Processor, BridgeProcessor};
use crate::ethereum::Ethereum;
use crate::server::data::ServerStatusResponse;

pub struct App {
    pub config: Config,
    pub database: Arc<Database>,
    pub bridge_processor: Arc<dyn Processor>,
}

use crate::server::error::Error as ServerError;

impl App {
    /// # Errors
    /// Will return `Err` if the internal Ethereum handler errors
    ///
    #[instrument(name = "App::new", level = "debug", skip_all)]
    pub async fn new(config: Config) -> anyhow::Result<Arc<Self>> {
        let db = Database::new(&config.database).await?;
        let database = Arc::new(db);
        let ethereum = Ethereum::new(&config).await?;
        let scroll_bridge = Arc::new(ScrollBridge::new(&config, ethereum.clone()).await?);
        let bridge_processor = Arc::new(
            BridgeProcessor::new(
                ethereum.clone(),
                scroll_bridge.clone()   
            )
            .await?
        );
        let app = Arc::new(Self {
            config,
            database,
            bridge_processor
        });
        Ok(app)
    }

    /// Initializes the server state.
    #[instrument(level = "debug", skip(self))]
    pub async fn initialize_server(&self) -> anyhow::Result<()> {
        if !self.database.server_initialized().await? {
            self.database.initialize_server().await?;
            self.database.mark_status_as_unsynced().await?;
        }
        info!("DB initialized");
        Ok(())
    }

    pub async fn get_service_status(&self) -> Result<ServerStatusResponse, ServerError>{
        let status = match  self.database.get_service_status().await? {
            Some(status) => status,
            None => return Err(ServerError::UNITIALIZED),
        };
        Ok(status.into())
    }
    
}
