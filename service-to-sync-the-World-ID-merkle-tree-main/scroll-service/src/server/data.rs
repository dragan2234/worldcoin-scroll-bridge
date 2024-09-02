use hyper::StatusCode;
use serde::{Deserialize, Serialize};
use crate::database::types::ServerStatus;

#[derive(Debug, Serialize, Deserialize, PartialEq)]
pub struct ServerStatusResponse(pub ServerStatus);


impl From<ServerStatus> for ServerStatusResponse {
    fn from(value: ServerStatus) -> Self {
        Self(value)
    }
}

impl ToResponseCode for ServerStatusResponse {
    fn to_response_code(&self) -> StatusCode {
        StatusCode::OK
    }
}


pub trait ToResponseCode {
    fn to_response_code(&self) -> StatusCode;
}

impl ToResponseCode for () {
    fn to_response_code(&self) -> StatusCode {
        StatusCode::OK
    }
}
