pub mod error;

use std::net::TcpListener;
use std::sync::Arc;
use std::time::Duration;

use axum::extract::State;
use axum::response::Response;
use axum::routing::get;
use axum::{middleware, Json, Router};
use error::Error;
use hyper::header::CONTENT_TYPE;
use hyper::{Body, StatusCode};
use prometheus::{Encoder, TextEncoder};
use tracing::info;

use crate::app::App;
use crate::config::ServerConfig;
use crate::utils::shutdown::Shutdown;
use self::data::{ToResponseCode, ServerStatusResponse};

mod custom_middleware;
pub mod data;


async fn fetch_service_status(
    State(app): State<Arc<App>>
) -> Result<(StatusCode, Json<ServerStatusResponse>), Error> {
    let result: ServerStatusResponse  = app.get_service_status().await?;
    Ok((result.to_response_code(), Json(result)))
}

async fn health() -> Result<(), Error> {
    Ok(())
}

async fn metrics() -> Result<Response<Body>, Error> {
    let encoder = TextEncoder::new();

    let metric_families = prometheus::gather();
    let mut buffer = vec![];
    encoder
        .encode(&metric_families, &mut buffer)
        .map_err(|e| Error::Other(e.into()))?;

    let response = Response::builder()
        .status(200)
        .header(CONTENT_TYPE, encoder.format_type())
        .body(Body::from(buffer))?;

    Ok(response)
}

/// # Errors
///
/// Will return `Err` if `options.server` URI is not http, incorrectly includes
/// a path beyond `/`, or cannot be cast into an IP address. Also returns an
/// `Err` if the server cannot bind to the given address.
pub async fn run(
    app: Arc<App>,
    config: ServerConfig,
    shutdown: Arc<Shutdown>,
) -> anyhow::Result<()> {
    info!("Will listen on {}", config.address);
    let listener = TcpListener::bind(config.address)?;

    bind_from_listener(app, config.serve_timeout, listener, shutdown).await?;

    Ok(())
}

/// # Errors
///
/// Will return `Err` if the provided `listener` address cannot be accessed or
/// if the server fails to bind to the given address.
pub async fn bind_from_listener(
    app: Arc<App>,
    serve_timeout: Duration,
    listener: TcpListener,
    shutdown: Arc<Shutdown>,
) -> anyhow::Result<()> {
    let router = Router::new()
        // Return service status
        .route("/serviceStatus", get(fetch_service_status))
        // Health check, return 200 OK
        .route("/health", get(health))
        .route("/metrics", get(metrics))
        .layer(middleware::from_fn(
            custom_middleware::api_metrics_layer::middleware,
        ))
        .layer(middleware::from_fn_with_state(
            serve_timeout,
            custom_middleware::timeout_layer::middleware,
        ))
        .layer(middleware::from_fn(
            custom_middleware::logging_layer::middleware,
        ))
        .layer(middleware::from_fn(
            custom_middleware::remove_auth_layer::middleware,
        ))
        .with_state(app.clone());

    let server = axum::Server::from_tcp(listener)?
        .serve(router.into_make_service())
        .with_graceful_shutdown(shutdown.await_shutdown());

    server.await?;

    Ok(())
}
