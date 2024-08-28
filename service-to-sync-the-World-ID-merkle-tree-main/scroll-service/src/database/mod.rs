#![allow(
    clippy::cast_sign_loss,
    clippy::cast_possible_truncation,
    clippy::cast_possible_wrap
)]

use std::cmp::Ordering;
use std::ops::Deref;

use anyhow::{anyhow, Context, Error as ErrReport};
use sqlx::migrate::{Migrate, MigrateDatabase, Migrator};
use sqlx::pool::PoolOptions;
use sqlx::{Executor, Pool, Postgres, Row};
use thiserror::Error;
use tracing::{error, info, instrument, warn};

use crate::config::DatabaseConfig;
use crate::database::query::DatabaseQuery;
// use crate::identity_tree::Hash;

pub mod query;
pub mod transaction;
pub mod types;

// Statically link in migration files
static MIGRATOR: Migrator = sqlx::migrate!("schemas/database");

pub struct Database {
    pub pool: Pool<Postgres>,
}

impl Deref for Database {
    type Target = Pool<Postgres>;

    fn deref(&self) -> &Self::Target {
        &self.pool
    }
}

impl<'a, T> DatabaseQuery<'a> for T where T: Executor<'a, Database = Postgres> {}

impl Database {
    #[instrument(skip_all)]
    pub async fn new(config: &DatabaseConfig) -> Result<Self, ErrReport> {
        info!(url = %&config.database, "Connecting to database");

        // Create database if requested and does not exist
        if config.migrate && !Postgres::database_exists(config.database.expose()).await? {
            warn!(url = %&config.database, "Database does not exist, creating database");
            Postgres::create_database(config.database.expose()).await?;
        }

        // Create a connection pool
        let pool = PoolOptions::<Postgres>::new()
            .max_connections(config.max_connections)
            .after_connect(|conn, _| {
                Box::pin(async move {
                    conn.execute("SET DEFAULT_TRANSACTION_ISOLATION TO 'SERIALIZABLE'")
                        .await?;
                    Ok(())
                })
            })
            .connect(config.database.expose())
            .await
            .context("error connecting to database")?;

        let version = pool
            .fetch_one("SELECT version()")
            .await
            .context("error getting database version")?
            .get::<String, _>(0);
        info!(url = %&config.database, ?version, "Connected to database");

        // Run migrations if requested.
        let latest = MIGRATOR
            .migrations
            .last()
            .expect("Missing migrations")
            .version;

        if config.migrate {
            info!(url = %&config.database, "Running migrations");
            MIGRATOR.run(&pool).await?;
        }

        // Validate database schema version
        let mut conn = pool.acquire().await?;

        if conn.dirty_version().await?.is_some() {
            error!(
                url = %&config.database,
                version,
                expected = latest,
                "Database is in incomplete migration state.",
            );
            return Err(anyhow!("Database is in incomplete migration state."));
        }

        let version = conn
            .list_applied_migrations()
            .await?
            .last()
            .expect("Missing migrations")
            .version;

        match version.cmp(&latest) {
            Ordering::Less => {
                error!(
                    url = %&config.database,
                    version,
                    expected = latest,
                    "Database is not up to date, try rerunning with --database-migrate",);
                return Err(anyhow!(
                    "Database is not up to date, try rerunning with --database-migrate"
                ));
            }
            Ordering::Greater => {
                error!(
                    url = %&config.database,
                    version,
                    latest,
                    "Database version is newer than this version of the software, please update.",);
                return Err(anyhow!(
                    "Database version is newer than this version of the software, please update."
                ));
            }
            Ordering::Equal => {
                info!(
                    url = %&config.database,
                    version,
                    latest,
                    "Database version is up to date.",
                );
            }
        }

        Ok(Self { pool })
    }
}

#[derive(Debug, Error)]
pub enum Error {
    #[error("database error: {0}")]
    InternalError(#[from] sqlx::Error),
}
