#![doc = include_str!("../Readme.md")]
#![warn(clippy::all, clippy::pedantic, clippy::cargo, clippy::nursery)]
#![allow(clippy::multiple_crate_versions, clippy::too_many_arguments)]



mod contracts;
mod ethereum;
mod processor;
mod database;
pub mod config;
pub mod task_monitor;
pub mod app;
pub mod server;
pub mod utils;
