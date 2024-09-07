# Worldcoin Scroll Bridge 

## Overview

### Project Description

The **Worldcoin Scroll Bridge** is a decentralized solution designed to securely propagate the World ID Merkle tree root from the Ethereum mainnet to various Layer 2 (L2) networks, including Optimism, Base, and Polygon PoS. This bridge allows for decentralized identity verification across these networks by ensuring that the latest World ID root is consistently and securely transmitted to the target networks.

This project is crucial for enabling seamless identity verification across different blockchain environments, thereby facilitating the adoption of World ID on L2 networks and beyond. The bridge's architecture is robust, ensuring high security and efficiency in cross-chain communication.

### Key Components

- **State Bridge Contracts**: Smart contracts deployed on Ethereum mainnet and L2 networks to manage the propagation of the World ID Merkle tree root.
- **Relayer Service**: A Rust-based automated service that periodically invokes the `propagateRoot()` function to ensure timely updates of the World ID root on the target networks.
- **Cross-Chain Messaging**: Leveraging native L1 <> L2 messaging protocols to ensure secure and reliable root propagation.

### Current State of the Project

The **Worldcoin Scroll Bridge** project is currently in a stable state with the following components fully functional:

1. **State Bridge Contracts**:
   - Deployed on Ethereum mainnet and supported L2 networks.
   - Audited by Nethermind, ensuring security and reliability.
  
2. **Relayer Service**:
   - Implemented in Rust to automate root propagation.
   - Runs on a cron job schedule, ensuring regular updates.
   - Tested and ready for deployment in both development and production environments.

3. **Supported Networks**:
   - Fully operational on Optimism, Base, and Polygon PoS.
   - Initial support for Scroll, with plans for expanding to more EVM-compatible networks.

4. **Future Proofing**:
   - The project is designed to integrate with upcoming storage proof solutions like Axiom and Herodotus.
   - Plans to expand support to a broader range of networks as these technologies mature.

5. **Documentation and Developer Support**:
   - Comprehensive documentation available for setup, deployment, and usage.
   - Active community and GitHub repository for contributions and support.


## Detailed Documentation

### 1. Architecture Overview

The **Worldcoin Scroll Bridge** architecture is designed to ensure secure and efficient cross-chain communication. The primary components include:

- **Mainnet Contract**: The contract on Ethereum mainnet fetches the latest World ID Merkle tree root from the `WorldIDIdentityManagerImplV1` contract using the `latestRoot()` method. This root is then sent to the target L2 networks using the native L1 <> L2 messaging layer.
  
- **L2 Contract**: The contract on the L2 network receives the propagated root and updates its state. Ownership and authorization checks are handled by the `CrossDomainOwnable3` contract, ensuring only the mainnet contract can initiate root propagation.

- **Relayer Service**: A Rust-based service that periodically calls the `propagateRoot()` function on the L2 contract. It is responsible for ensuring that the World ID root is consistently propagated to the target networks.

### 2. Supported Networks

The **Worldcoin Scroll Bridge** currently supports the following networks:

- **Polygon PoS**: Provides backward compatibility with earlier versions of the World ID system.
- **Optimism**: Uses the Optimism cross-domain messenger for root propagation.
- **Base**: Fully integrated with the World ID system.
- **Scroll**: Initial support with ongoing improvements and optimizations.

### 3. Future Integrations

The bridge is designed to support additional networks in the future, with a focus on storage proof solutions such as Axiom and Herodotus. These integrations will enable seamless and cost-effective cross-chain identity verification, expanding World ID's reach to a wider range of blockchain environments.

### 4. Relayer Service Implementation

The **Relayer Service** automates the process of propagating the World ID root from Ethereum mainnet to the Scroll network. Key implementation details include:

- **Rust Environment Setup**: The service is implemented in Rust, ensuring high performance and reliability. It uses a cron job to schedule periodic calls to the `propagateRoot()` function.
  
- **Interaction with Smart Contracts**: The service interacts with the ScrollStateBridge contract on the L2 network, sending transactions to propagate the World ID root.

- **Production Deployment**: The service is containerized using Docker for easy deployment and scaling. Monitoring and logging are integrated to ensure smooth operation.

### 5. Installation and Setup

To set up the **Worldcoin Scroll Bridge** and the accompanying Relayer Service, follow these steps:

#### Install Dependencies

Clone the repository and install the necessary dependencies:

```bash
git clone https://github.com/worldcoin-scroll-bridge.git
cd worldcoin-scroll-bridge
make install
```
**Build Contracts**
Compile the smart contracts:

```
make build
```

**Clean Build Artifacts**
Remove build artifacts and cache directories:

```
make clean
```
**Usage Guide**
Deploying Contracts
Deploy the contracts to the desired network using the provided deployment scripts. Ensure that the target network supports the required cryptographic operations and messaging protocols.

**Running the Relayer Service**
Set up and run the Relayer Service to automate the propagation of the World ID root:

1. Initialize Rust Environment: Ensure Rust is installed and set up on your system.
2. Install Required Packages:  Install the necessary Rust crates for Ethereum client interaction and cron scheduling.
3. Run the Service: Execute the Rust program to start the Relayer Service, and monitor the logs to ensure successful root propagation.
4. Deployment and Production
For deploying the Worldcoin Scroll Bridge and Relayer Service in a production environment, follow these steps:

- Dockerize the Service: Use Docker to containerize the service, making it easier to deploy and manage across different environments.
- Set Up Monitoring: Integrate monitoring tools to track the performance and reliability of the Relayer Service.
- Security Best Practices: Implement security measures to protect private keys and sensitive data, ensuring the integrity of the bridge.
- Contributing to the Project
We welcome contributions from the community to improve the Worldcoin Scroll Bridge. Whether it's fixing bugs, adding new features, or improving documentation, your input is valuable.
**Contributions**
- Fork the Repository: Start by forking the repository and cloning it locally.
- Make Your Changes: Implement your changes and test them thoroughly.
- Submit a Pull Request: Once you're satisfied with your changes, submit a pull request for review.
For detailed guidelines, refer to the CONTRIBUTING.md file in the repository.

License
The Worldcoin Scroll Bridge project is licensed under the MIT License. For more information, see the LICENSE file in the repository.
