// use chrono::{DateTime, Utc};
use sqlx::{Executor, Postgres, Row};

use crate::database::{types, Error};

use crate::processor::status::BridgeStatus;
use types::{ServerStatus, TxStatus};

/// This trait provides the individual and composable queries to the database.
/// Each method is a single atomic query, and can be composed within a
/// transaction.
pub trait DatabaseQuery<'a>: Executor<'a, Database = Postgres> {

    async fn initialize_server(
        self,
    ) -> Result<(), Error> {
        let initialize_server_query = sqlx::query(
            r#"
            INSERT INTO service_status (status, last_synced)
            VALUES ($1, CURRENT_TIMESTAMP)
            "#,
        )
        .bind(<&str>::from(BridgeStatus::Unsynced));

        self.execute(initialize_server_query).await?;
        Ok(())
    }

    async fn server_initialized(self) -> Result<bool, Error> {
        Ok(sqlx::query(
            r#"
            select
            EXISTS (select id from service_status where id = 1)
            "#,
        )
        .fetch_one(self)
        .await?
        .get::<bool, _>(0))
    }

    async fn insert_new_transaction(
        self,
        transaction_id: &String
    ) -> Result<(), Error> {
        let query = sqlx::query(
            r#"
            INSERT INTO transactions(
                transaction_id,
                created_at
            ) VALUES ($1, CURRENT_TIMESTAMP)
            "#,
        )
        .bind(transaction_id);
        self.execute(query).await?;
        Ok(())
    }

    async fn update_transaction(
        self,
        transaction_id: &String,
        tx_status: TxStatus,
    ) -> Result<(), Error> {
        let query = sqlx::query(
            r#"
            UPDATE transactions
            SET status = $1
            WHERE transaction_id = $2
            "#,
        )
        .bind(tx_status)
        .bind(transaction_id);
        self.execute(query).await?;
        Ok(())
    }


    async fn update_server_status(
        self,
        status: BridgeStatus
    ) -> Result<(), Error> {
        let query = if matches!(status, BridgeStatus::Synced) {
            // Update the status and last_synced if the status is Synced
            sqlx::query(
                r#"
                UPDATE service_status
                SET status = $1, last_synced = CURRENT_TIMESTAMP
                WHERE id = 1
                "#
            )
            .bind(status)
        } else {
            // Only update the status if the status is not Synced
            sqlx::query(
                r#"
                UPDATE service_status
                SET status = $1
                WHERE id = 1
                "#
            )
            .bind(<&str>::from(status))
        };

        self.execute(query).await?;
        Ok(())
    }

    async fn get_last_transaction_status(
        self
    ) -> Result<Option<TxStatus>, Error> {
        let query = sqlx::query(
            r#"
            SELECT status
            FROM transactions
            ORDER BY created_at DESC
            LIMIT 1;
            "#
        );
        let row = self.fetch_optional(query).await?;

        Ok(row.map(|r| r.get::<TxStatus, _>(0)))
    }

    async fn get_last_transaction_id(
        self
    ) -> Result<Option<String>, Error> {
        let query = sqlx::query(
            r#"
            SELECT transaction_id
            FROM transactions
            WHERE status = $1
            ORDER BY created_at DESC
            LIMIT 1;
            "#
        ).bind(TxStatus::Pending);
        let row = self.fetch_optional(query).await?;

        Ok(row.map(|r| r.get::<String, _>(0)))
    }

    async fn get_service_status(self) -> Result<Option<ServerStatus>, Error> {
        Ok(sqlx::query_as::<_, ServerStatus>(
            r#"
            SELECT status, last_synced
            FROM service_status
            WHERE id = 1
            "#
        )
        .fetch_optional(self)
        .await?)
    }

    async fn get_db_status(self) -> Result<Option<String>, Error> {
        let query = sqlx::query(
            r#"
            SELECT status
            FROM service_status
            WHERE id = 1
            "#
        );
        let row = self.fetch_optional(query).await?;
        Ok(row.map(|r| r.get::<String, _>(0)))
    }

    // async fn get_last_sync_timestamp(self) -> Result<Option<DateTime<Utc>>, Error> {
    //     let query = sqlx::query(
    //         r#"
    //         SELECT last_synced
    //         FROM service_status
    //         WHERE id = 1
    //         "#
    //     );
    //     let row = self.fetch_optional(query).await?;
    //     Ok(row.map(|r| r.get::<DateTime<Utc>, _>(0)))
    // }
}
