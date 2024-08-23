#![doc = include_str!("../Readme.md")]
#![warn(clippy::cargo)]
#![allow(
    clippy::module_name_repetitions,
    clippy::wildcard_imports,
    clippy::multiple_crate_versions
)]

use std::path::PathBuf;
use std::sync::Arc;

use clap::Parser;
use scroll_service::app::App;
use scroll_service::config::{load_config, ServiceConfig};
use scroll_service::server;
use scroll_service::utils::shutdown::{watch_shutdown_signals, Shutdown};
use scroll_service::task_monitor::TaskMonitor;
use telemetry_batteries::tracing::datadog::DatadogBattery;
use telemetry_batteries::tracing::stdout::StdoutBattery;
use telemetry_batteries::tracing::TracingShutdownHandle;

#[derive(Debug, Clone, Parser)]
struct Args {
    /// Path to the optional config file
    config: Option<PathBuf>,
}

#[tokio::main]
async fn main() -> eyre::Result<()> {
    let args = Args::parse();
    // telemetry_batteries::init()?;
    scroll_service(args)
        .await
        .map_err(|e| eyre::eyre!("{:?}", e))
}

async fn scroll_service(args: Args) -> anyhow::Result<()> {

    let config = load_config(args.config.as_deref())?;

    let _tracing_shutdown_handle = init_telemetry(&config.service)?;

    let shutdown = Arc::new(Shutdown::new());

    watch_shutdown_signals(shutdown.clone());

    let version = env!("GIT_VERSION");

    tracing::info!(?config, version, "Starting the app");

    let server_config = config.server.clone();

    // Create App struct
    let app = App::new(config).await?;

    app.initialize_server().await?;

    let task_monitor = TaskMonitor::new(app.clone(), shutdown.clone());

    // Process to push new identities to Ethereum
    task_monitor.start().await;

    // Start server (will stop on shutdown signal)
    server::run(app, server_config, shutdown.clone()).await?;

    tracing::info!("Stopping the app");
    task_monitor.shutdown().await?;

    Ok(())
}

fn init_telemetry(service: &ServiceConfig) -> anyhow::Result<TracingShutdownHandle> {
    if let Some(ref datadog) = service.datadog {
        Ok(DatadogBattery::init(
            datadog.traces_endpoint.as_deref(),
            &service.service_name,
            None,
            true,
        ))
    } else {
        Ok(StdoutBattery::init())
    }
}
