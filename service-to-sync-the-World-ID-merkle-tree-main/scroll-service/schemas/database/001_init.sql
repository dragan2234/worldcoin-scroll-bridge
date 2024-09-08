CREATE TABLE service_status (
    id SERIAL PRIMARY KEY,
    status VARCHAR(50) NOT NULL,
    last_synced TIMESTAMPTZ NULL
);