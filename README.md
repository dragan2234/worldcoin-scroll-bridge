
# Worldcoin Scroll Bridge

The **Worldcoin Scroll Bridge** facilitates the transfer of the World ID Merkle tree root from Ethereum mainnet to the Scroll Layer 2 (L2) network. This enables seamless identity verification on Scroll by synchronizing the latest Merkle root between the two networks.


## Intro

The **Worldcoin Scroll Bridge** connects Ethereum mainnet to Scroll L2, allowing the transfer of the World ID Merkle tree root. This root is crucial for verifying inclusion proofs via Semaphore on Scroll. The bridge ensures that Scroll stays up to date with the latest Merkle root generated on Ethereum.

The design leverages Scroll’s native L1<>L2 messaging layer, enabling secure and reliable communication between Ethereum and Scroll.

The core principle of the bridge contracts is to fetch the latest root of the World ID Merkle tree from the [`WorldIDIdentityManagerImplV1`](https://github.com/worldcoin/world-id-contracts/blob/main/src/WorldIDIdentityManagerImplV1.sol) contract deployed on Ethereum. The fetched root is then propagated to the Scroll L2 network via the L1<>L2 messaging layer.

## Bridge Architecture

### Overview

The Worldcoin Scroll Bridge project is currently in a stable state with the following components fully functional:

1.State Bridge Contracts:
Deployed on Ethereum mainnet and supported L2 networks.

2. Relayer Service:
Implemented in Rust to automate root propagation.
Runs on a cron job schedule, ensuring regular updates.
Tested and ready for deployment in both development and production environments.


More about the Relayed Service setup can be found in this PR together with the video explanation how to setup locally:
https://github.com/dragan2234/worldcoin-scroll-bridge/pull/17


### Architecture Overview
The Worldcoin Scroll Bridge architecture is designed to ensure secure and efficient cross-chain communication. The primary components include:

1. Mainnet Contract: The contract on Ethereum mainnet fetches the latest World ID Merkle tree root from the WorldIDIdentityManagerImplV1 contract using the latestRoot() method. This root is then sent to the target L2 networks using the native L1 <> L2 messaging layer.

2. L2 Contract: The contract on the L2 network receives the propagated root and updates its state. Ownership and authorization checks are handled by the ScrollCrossDomainOwnable contract, ensuring only the mainnet contract can initiate root propagation.

3. Relayer Service: A Rust-based service that periodically calls the propagateRoot() function on the L2 contract. It is responsible for ensuring that the World ID root is consistently propagated to the target networks.


## Requirements

### Dependencies

To successfully deploy and operate the Scroll Bridge, the following prerequisites are necessary:

1. **World ID Merkle Tree Sync**:
   - The Merkle tree syncing service must be operational, which is currently done by the [`signup-sequencer`](https://github.com/worldcoin/signup-sequencer).

2. **Scroll Network Support**:
   - Scroll must support EVM-compatible environments, particularly pairing cryptography and keccak256 precompiles.

3. **Scroll L1<>L2 Messaging Layer**:
   - The native messaging layer on Scroll will transmit the Merkle root from Ethereum to Scroll.

4. **Relayer Service**:
   - A relayer service (such as the [`state-bridge-relay`](https://github.com/worldcoin/state-bridge-relay)) will periodically trigger the `propagateRoot()` function on Ethereum to send the latest root to Scroll.

## Contract Specifications

### Key Contracts

1. **ScrollStateBridge (Mainnet Contract)**:
   - Fetches the latest World ID Merkle root from the `WorldIDIdentityManagerImplV1` contract on Ethereum.
   - Propagates the root to Scroll via the Scroll L1<>L2 messaging layer.

2. **ScrollWorldID (L2 Contract)**:
   - Receives and stores the propagated root for verifying Semaphore proofs on Scroll.

### Key Methods

- **`propagateRoot()`**:
   - This method fetches the latest Merkle root from Ethereum and sends it to Scroll using the native L1<>L2 messaging system.

- **`setRootHistoryExpiry()`**:
   - Sets the expiry period for a propagated root, specifying how long the root is valid for inclusion proofs on Scroll.

## Setting up the Scroll Bridge

### Step-by-Step Guide

1. **Deploy ScrollStateBridge on Ethereum**:
   - This contract communicates with the [`WorldIDIdentityManagerImplV1`](https://github.com/worldcoin/world-id-contracts/blob/main/src/WorldIDIdentityManagerImplV1.sol) to retrieve the latest Merkle root from Ethereum.

2. **Deploy ScrollWorldID on Scroll**:
   - This contract will receive the Merkle root propagated from Ethereum and store it for proof verifications on Scroll.

3. **Configure the Relayer**:
   - Set up the relayer service (e.g., [`state-bridge-relay`](https://github.com/worldcoin/state-bridge-relay)) to periodically trigger the `propagateRoot()` function on Ethereum.

4. **Set Up L1<>L2 Messaging Contracts**:
   - Deploy the necessary L1<>L2 messaging contracts for Scroll and ensure proper communication between Ethereum and Scroll.

## Deployment and Messaging

### Messaging Layer

The Scroll Bridge utilizes Scroll’s native L1<>L2 messaging layer to propagate the latest World ID Merkle root from Ethereum to Scroll. This enables the Scroll L2 network to remain synchronized with the most recent Merkle root from Ethereum for proof verification.

### Deployment

Deployment scripts are available and can be customized for specific environments. Make sure to update the deployment scripts with the correct messaging addresses for Scroll’s L1<>L2 layer.

## Security Considerations

1. **Authorized Root Propagation**:
   - Ensure that only the Ethereum mainnet contract can propagate roots to Scroll. This prevents unauthorized users from inserting malicious or arbitrary roots.

2. **Relayer Configuration**:
   - The relayer service should be properly configured to periodically call the `propagateRoot()` function, ensuring that Scroll remains up to date with the latest Merkle root.

3. **Contract Permissions**:
   - Use contracts like [`CrossDomainOwnable3`](https://github.com/ethereum-optimism/optimism/blob/develop/packages/contracts-bedrock/src/L2/CrossDomainOwnable3.sol) to restrict access, ensuring only authorized entities can propagate roots to the Scroll network.

## How to Contribute

We welcome contributions from developers who are passionate about decentralized identity solutions and the Scroll network. Below are the guidelines for contributing to the Scroll Bridge project:

### 1. Fork the Repository

To start contributing, fork the repository to your own GitHub account by clicking the "Fork" button at the top of the repository page.

### 2. Clone Your Fork Locally

Clone your fork of the repository to your local machine using the following command:

```bash
git clone https://github.com/your-username/world-id-scroll-bridge.git
cd world-id-scroll-bridge
```

### 3. Create a New Branch

Before making any changes, create a new branch for your feature or fix. This ensures that your `main` branch remains clean.

```bash
git checkout -b feature/your-feature-name
```

### 4. Make Your Changes

Start implementing your feature or fix. Make sure to follow coding best practices and write clear, concise commit messages. If you are adding a new feature or modifying existing functionality, ensure that it is fully tested.

### 5. Add Tests

Contributions that introduce new features should include appropriate unit tests. If you're fixing an issue, try to include a test that covers the specific bug to prevent regressions in the future.




----- 

# Old docs:

# worldcoin-scroll-bridge

Docs copied from: https://github.com/worldcoin/world-id-state-bridge/pull/112



### Build your own state bridge

#### Intro

The point of the state bridge contracts in `world-id-state-bridge` is to have two contracts, one deployed on Ethereum
mainnet and the other one on a target L2. The mainnet contract (e.g. `OpStateBridge`) has a public function which will
fetch the latest root of the World ID merkle tree using the
[`WorldIDIdentityManagerImplV1`](https://github.com/worldcoin/world-id-contracts/blob/main/src/WorldIDIdentityManagerImplV1.sol)
method named
[`latestRoot()`](https://github.com/worldcoin/world-id-contracts/blob/42c26ecbd82fba56983addee6485d5b617960a2a/src/WorldIDIdentityManagerImplV1.sol#L433-L438)
and then will use the native L1<>L2 messaging layer to send a message to the target L2 contract (e.g. `OpWorldID`). The
messaging layer of the L2 will forward the message to the target contract by calling the corresponding method on the L2
contract with the specified payload from the L1.

> [!NOTE] The current implementation of WorldID will only work for EVM-compatible networks as mentioned in the
> [Supported networks](#supported-networks) and [Future integrations](#future-integrations) sections. If you are an
> EVM-compatible rollup you also need to support the pairing cryptography and keccak256 precompiles.
The root of the World ID Identity Manager tree is the only public state that you need to send to the L2 in order to
verify Semaphore proofs (proofs of inclusion in the World ID merkle tree). As long as you have the root and a World ID
implementation on your network, you can deploy World ID on it.

#### Requirements

- service to sync the World ID merkle tree (currently only done by
  [`signup-sequencer`](https://github.com/worldcoin/signup-sequencer))
- EVM support on the L2 (pairing cryptography and keccak256 precompile support needed)
  - or a custom implementation of World ID for your execution environment (see
    [Future integrations](#future-integrations))
- native L1<>L2 data messaging layer (e.g. Optimism cross domain messenger, Arbitrum, etc)
- relayer service that periodically calls `propagateRoot()` as a cron job (e.g.
  [`state-bridge-relay`](https://github.com/worldcoin/state-bridge-relay))
- deployment scripts
- audits (World ID contracts, both `world-id-contracts` and `world-id-state-bridge` are audited by Nethermind
  ([1](https://github.com/NethermindEth/PublicAuditReports/blob/main/NM0131-FINAL_WORLDCOIN_STATE_BRIDGE_CONTRACTS_UPGRADE.pdf),
  [2](https://github.com/NethermindEth/PublicAuditReports/blob/main/NM0122-FINAL_WORLDCOIN.pdf)))

#### Specification

If you want to build your own state bridge, you can use the `OpStateBridge` contract as a template. The contract has two
main methods, namely
[`propagateRoot()`](https://github.com/worldcoin/world-id-state-bridge/blob/main/src/OpStateBridge.sol#L126) (fetches
the latest root from the
[Orb/Phone World ID IdentityManager contract](https://docs.worldcoin.org/reference/address-book) and propagates it to
the target L2 contract using the native L1->L2 messaging layer) and
[`setRootHistoryExpiry()`](https://github.com/worldcoin/world-id-state-bridge/blob/main/src/OpStateBridge.sol#L170)
(sets how long you want a propagated root to be valid for inclusion proofs) which you will need to implement. Most
native bridges will have a messenger/relayer contract and a generic interface you can use to call a function on a target
contract on the L2 with your desired calldata (which is the message). Another requirement for this system to work is to
only allow the contract on L1 to be able to call this function on the L2, otherwise anyone would be able to insert
arbitrary merkle tree roots into the L2 contract. On the `OpWorldID` contract we used a contract named
[`CrossDomainOwnable3`](https://github.com/ethereum-optimism/optimism/blob/develop/packages/contracts-bedrock/src/L2/CrossDomainOwnable3.sol)
which implements this functionality (checks that L1 sender is a given sender).

> [!NOTE] If you want to support World ID on an OP-stack network it is very easy as we have already implemented it for
> Optimism, the only change you need to make is within the deploy scripts where you need to set the
> [crossDomainMessengerAddress](https://github.com/worldcoin/world-id-state-bridge/blob/main/src/script/deploy/op-stack/optimism/DeployOptimismStateBridgeGoerli.s.sol#L32)
> to the your own network's cross domain messenger address on Ethereum L1 (whether mainnet or testnet).

------
