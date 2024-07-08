## Introduction
This project is for bridging the worldcoin state (such as the merkle root) from ethereum to scroll.

The task at hand was maintained in:
https://github.com/SwineCoder101/world-id-state-bridge/tree/scroll-integration

## What has been implemented
For this task we need to create and deploy the following contracts to scroll:

    ScrollWorldID.sol - maintain the state of worldcoin merklet root
    ScrollStateBridge.sol - Entry point for distributing the world id manager roots to scroll

These have already been implemented for optimism and have now been altered for scroll.
unit test for the state bridge can be found in ScrollStateBridge.t.sol
https://github.com/worldcoin/world-id-state-bridge/commit/f950814350f22a2e3ba116f508ff00612183a014

The deployment script has been altered for scroll integration, details of the commit can be found in:
https://github.com/worldcoin/world-id-state-bridge/commit/9853abd63b9eef25afa71e85a5b0abde8254bd24

## Prerequisites
Ensure to install foundry ,node, yarn, make
foundry: https://book.getfoundry.sh/getting-started/installation
node: https://nodejs.org/en/download/package-manager
yarn: https://classic.yarnpkg.com/lang/en/docs/install/#mac-stable
make: https://formulae.brew.sh/formula/make

## How to build and test the project

### Install Dependencies
```sh
make install
```

### Build

Build the contracts:

```sh
make build
```

### Clean

Delete the build artifacts and cache directories:

```sh
make clean
```

### Coverage

Get a test coverage report:

```sh
make coverage
```

### Format

Format the contracts with `forge fmt` and the rest of the files (.js, .md) with Prettier:

```sh
make format
```

### Gas Usage

Get a gas report:

```sh
make snapshot
```

```sh
make bench
```

### Lint

Lint the contracts:

```sh
make lint
```

### Test

Run the tests:

```sh
make test
```

## How to deploy
Once the project is fully compiled and built, the abis and interfaces will be generated in the out dir.
copy over the .env.example to .env and create a key pair wallet in metamask or through forge and update the PRIVATE_KEY env var DEPLOYER_ADDRESS.

Ensure to fund this wallet with sepolia eth and scroll sepolia eth to bridge and update the state of the worldcoin merkle root.

### Deploy
run:
`make deploy-testnet`
