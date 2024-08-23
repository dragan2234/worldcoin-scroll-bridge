use anyhow::Error as EyreError;
use axum::response::IntoResponse;
use hyper::StatusCode;
use thiserror::Error;

use crate::database;

#[derive(Debug, Error)]
pub enum Error {
    #[error(transparent)]
    Elapsed(#[from] tokio::time::error::Elapsed),
    #[error("Failed to propagate root")]
    FailedToPropagate,
    #[error("invalid JSON request: {0}")]
    InvalidSerialization(#[from] serde_json::Error),
    #[error(transparent)]
    Hyper(#[from] hyper::Error),
    #[error(transparent)]
    Http(#[from] hyper::http::Error),
    #[error("invalid http method")]
    InvalidMethod,
    #[error("invalid path")]
    InvalidPath,
    #[error("invalid content type")]
    InvalidContentType,
    #[error("Root mismatch between world-id and scroll-world-id.")]
    RootMismatch,
    #[error("service is not initialized")]
    UNITIALIZED,
    #[error(transparent)]
    Database(#[from] database::Error),
    #[error(transparent)]
    Other(#[from] EyreError),
}

impl Error {
    fn to_status_code(&self) -> StatusCode {
        match self {
            Self::InvalidMethod => StatusCode::METHOD_NOT_ALLOWED,
            Self::InvalidPath => StatusCode::NOT_FOUND,
            Self::InvalidContentType => StatusCode::UNSUPPORTED_MEDIA_TYPE,
            Self::InvalidSerialization(_) => {
                StatusCode::BAD_REQUEST
            }
            _ => StatusCode::INTERNAL_SERVER_ERROR,
        }
    }
}

impl IntoResponse for Error {
    fn into_response(self) -> axum::response::Response {
        let status_code = self.to_status_code();

        let body = if let Self::Other(err) = self {
            format!("{err:?}")
        } else {
            self.to_string()
        };

        (status_code, body).into_response()
    }
}
