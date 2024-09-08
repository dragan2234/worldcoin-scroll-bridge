CREATE TYPE tx_status AS ENUM ('pending', 'mined', 'finalized');

CREATE TABLE transactions
  (
    transaction_id  VARCHAR(256) NOT NULL UNIQUE PRIMARY KEY,
    status    tx_status    NOT NULL DEFAULT 'pending',
    created_at      TIMESTAMPTZ  NOT NULL
  );