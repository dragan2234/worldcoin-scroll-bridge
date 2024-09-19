# Worldcoin Scroll Bridge

## Overview

### Project Description
The **Worldcoin Scroll Bridge** is a decentralized solution designed to securely propagate the World ID Merkle tree root from the Ethereum mainnet to the **Scroll** Layer 2 network. This bridge ensures that the latest World ID root is consistently and securely transmitted to Scroll, facilitating reliable decentralized identity verification within this Layer 2 environment.

### Key Components
- **State Bridge Contracts**: There are two key smart contracts involved in the bridge's operation:
  - **Mainnet Contract**: Deployed on Ethereum mainnet. This contract fetches the latest World ID Merkle tree root using the `latestRoot()` method from the `WorldIDIdentityManagerImplV1` contract and sends it to the Scroll network.
  - **Scroll Contract**: Deployed on the Scroll network. This contract receives the propagated root and updates its state. It relies on the native L1 <> L2 messaging layer for secure communication.

- **Relayer Service**: Implemented in Rust to automate root propagation..

### Current State of the Project
The **Worldcoin Scroll Bridge** is in a stable state, with the following components fully operational:

1. **State Bridge Contracts**:
   - **Ethereum Mainnet Contract**: Fetches the latest World ID root using the `latestRoot()` method.
   - **Scroll Contract**: Receives and updates the World ID root on Scroll.
   - Contracts are deployed and operational but have not been audited yet.

2. **Relayer Service**:
   - Implemented in Rust for high performance and reliability.
   - Runs on a cron job schedule for regular updates.
   - Fully tested and ready for deployment in both development and production environments.

### Documentation and Developer Support
- Comprehensive documentation is available for setup, deployment, and usage.
- Active community and GitHub repository for contributions and support.

## Detailed Documentation

### 1. Architecture Overview
The **Worldcoin Scroll Bridge** architecture is designed to ensure secure and efficient cross-chain communication. Key components include:

- **Mainnet Contract**: Deployed on Ethereum mainnet, this contract uses the `latestRoot()` method from the `WorldIDIdentityManagerImplV1` contract to fetch the latest World ID Merkle tree root. It then sends this root to the Scroll network via the native L1 <> L2 messaging layer.

- **Scroll Contract**: Deployed on Scroll, this contract receives the propagated root and updates its state. It ensures that only the mainnet contract can initiate root propagation, handled by the `CrossDomainOwnable3` contract.

- **Relayer Service**: Periodically calls the `propagateRoot()` function on the Scroll contract to ensure the World ID root is consistently propagated.

### 2. Specification for Building State Bridges
If you are looking to build your own state bridge, the `OpStateBridge` contract can serve as a template. Key methods to implement include:
- **`propagateRoot()`**: Method to propagate the latest World ID root to the target contract.
- **`setRootHistoryExpiry()`**: Method to manage the expiry of root history.

### 3. Installation and Setup
To set up the **Worldcoin Scroll Bridge** and the accompanying Relayer Service, follow these steps:

#### Install Dependencies
```bash
git clone https://github.com/worldcoin-scroll-bridge.git
cd worldcoin-scroll-bridge
make install
```

#### Build Contracts
Compile the smart contracts:
```bash
make build
```

#### Clean Build Artifacts
Remove build artifacts and cache directories:
```bash
make clean
```

### Usage Guide

#### Deploying Contracts
Deploy the contracts to Ethereum mainnet and the Scroll network using the provided deployment scripts. Ensure the target network supports necessary cryptographic operations and messaging protocols.

#### Running the Relayer Service
1. **Initialize Rust Environment**: Ensure Rust is installed on your system.
2. **Install Required Packages**: Install necessary Rust crates for Ethereum client interaction and cron scheduling.
3. **Run the Service**: Execute the Rust program to start the Relayer Service and monitor the logs for successful root propagation.

### Deployment and Production

#### Dockerize the Service
Use **Docker** to containerize the service for deployment and management.

#### Set Up Monitoring
Integrate monitoring tools to track the performance and reliability of the Relayer Service.

#### Security Best Practices
Implement measures to protect private keys and sensitive data, ensuring the bridge's integrity.



## Contributing to the Project

We welcome contributions to improve the **Worldcoin Scroll Bridge**. Whether fixing bugs, adding new features, or improving documentation, your input is valuable.

### Contributions
1. **Fork the Repository**: Fork and clone the repository locally.
2. **Make Your Changes**: Implement and test your changes.
3. **Submit a Pull Request**: Submit a pull request for review. Refer to the `CONTRIBUTING.md` file for guidelines.

### Additional Resources
- [Pull Request #112: Enhancements and Fixes](https://github.com/worldcoin/world-id-state-bridge/pull/112)

This README is tailored specifically for the **Worldcoin Scroll Bridge** and reflects accurate details and resources. If you have any further updates or corrections, please let me know!
