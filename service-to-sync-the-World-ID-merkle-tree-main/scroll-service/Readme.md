# SCROLL BRIDGE SERVICE

![lines of code](https://img.shields.io/tokei/lines/github/recmo/rust-service-template)
[![dependency status](https://deps.rs/repo/github/recmo/rust-service-template/status.svg)](https://deps.rs/repo/github/recmo/rust-service-template)
[![codecov](https://img.shields.io/codecov/c/github/recmo/rust-service-template)](https://codecov.io/gh/Recmo/rust-service-template)
[![Build, Test & Deploy](https://github.com/recmo/rust-service-template/actions/workflows/build-test-deploy.yml/badge.svg)](https://github.com/recmo/rust-service-template/actions/workflows/build-test-deploy.yml)

## Basic Overview of the Task Manager Service

The Task Manager service is designed to ensure consistency between two blockchain environments—specifically, the Scroll World ID contract and the Mainnet World ID contract. This service plays a critical role in maintaining data integrity across these decentralized platforms by comparing the latest roots (Merkle tree roots) recorded in both contracts. Here’s how the service works in detail:

### Value Comparison

The Task Manager continuously monitors the Scroll World ID contract and the Mainnet World ID contract to fetch the latest roots comparing them to check for discrepancies.

### Triggering the Propagate Root Task

If the roots from the Scroll and Mainnet contracts are found to be unequal, it indicates that the two environments are out of sync. To resolve this, the Task Manager triggers the **Propagate Root** task. This task ensures that the root from the Mainnet World ID is propagated to the Scroll World ID, thereby aligning both environments.

### Transaction Generation and Mining

Once the Propagate Root task is triggered, it generates a transaction ID (txId). This transaction is then sent to the network, where a relayer service takes over to ensure that the transaction is mined. This process effectively updates the root on the Scroll World ID to match that of the Mainnet World ID.

### Sync State Endpoint

The service also offers an endpoint that provides real-time information on the synchronization status between the Scroll World ID and the Mainnet World ID. Through this endpoint, users can:

- Check the Current Sync State: Determine whether the roots of the Scroll and Mainnet contracts are aligned or if a discrepancy exists.
- Monitor the Last Sync Action: View the timestamp of the last successful synchronization action.
This allows users to easily monitor the synchronization status and ensure that both environments remain consistent.

`/serviceStatus` - returns the server status

## GETTING STARTED

### (Local development)

Install pre-requisites on the dev machine

| Os            | Command                                                |
| ------------- | ------------------------------------------------------ |
| MacOs         | `brew install protobuf pkg-config`                     |
| Ubuntu/Debian | `sudo apt-get install -y protobuf-compiler pkg-config` |

Install [Docker](https://docs.docker.com/get-docker/) - Docker is used to setup the database for testing

Fetch the [postgres](https://hub.docker.com/_/postgres) docker image before running tests.

```shell
docker pull postgres
```

### Local Node

You'll need to run a local node like geth or [ganache](https://archive.trufflesuite.com/ganache/). Start up a new chain
and take note of the dev addresses. You can follow instructions [here](https://book.getfoundry.sh/anvil/).

### Contracts

You need the Scroll Bridge Contract which is used by the service to propagate the root, while the scroll world id contract and the L1 world contract address, are read from the bridge contract public states.

Clone [scroll-bridge-deployer](https://github.com/dragan2234/worldcoin-scroll-bridge.git) and follow the steps in the readme there.

### Database

```shell
docker run --rm -e POSTGRES_HOST_AUTH_METHOD=trust -p
```

### Relayer Service

#### 1. TX sitter

TX sitter is a service providing API for service to submit transactions on blockchain.

Clone [tx-sitter-monolith](https://github.com/worldcoin/tx-sitter-monolith) and follow build instructions

#### 2. OZ Relayer

Another popular relayer service used to submit transactions on the blockchain.

Check [here](https://docs.openzeppelin.com/defender/manage/relayers) for instructions on how to set up.

### SERVICE

Now you need to create a `config.toml` file for signup-sequencer:

```toml
[app]

[network]
# Address of ScrollBridge contract on blockchain.
# This is an active one on sepolia
scroll_bridge_address = '0xA268281948353043A79d1da3cd173019e29d9d91'

[providers]
# Blockchain API URL (anvil or geth or public rpc)
l1_network_provider = "https://eth-sepolia.g.alchemy.com/v2/" 
l2_network_provider = "https://scroll-public.scroll-testnet.quiknode.pro" 

[relayer]
kind = "tx_sitter"
# URL of TX-sitter API + API token
tx_sitter_url = "http://localhost:3000/1/api/YKxkLHafQQi83-kMmt9_SrGTQ7wEMBwY9bEqCvddBKU="
tx_sitter_address = "0x8f643b962d6d6120ef8a9c3f3428b5e487b75daf"
tx_sitter_gas_limit = 2000000

[database]
database = "postgres://postgres:password@localhost:5432/service?sslmode=disable"

[server]
# Port to run service API on
address = "0.0.0.0:8080"
```

The daemon will try to create temporary files in `/data`. If your machine does not have it you could create it:

```shell
mkdir service_data
sudo ln -sf `pwd`/service /data
```

And then run the daemon:

```shell
RUST_LOG=info cargo run config.toml
```

## Contributing

We welcome your pull requests! But also consider the following:

1. Fork this repo from `main` branch.
2. If you added code that should be tested, please add tests.
3. If you changed the API routes, please update this readme in your PR.
4. Ensure that CI tests suite passes (lints as well).
5. If you added dependencies, make sure you add exemptions for `cargo vet`

When you submit code changes, your submissions are understood to be under the same MIT License that covers the project.
Feel free to contact the maintainers if that's a concern.

Report bugs using github issues.
