## Documentation and Research on Data Messaging Between L1 (Ethereum) and L2 (Scroll) Layers Using the Scroll L2 Platform

This document provides a detailed investigation into the process of messaging data between the native `L1 (Ethereum)` and `L2 (Scroll)` layers using the Scroll L2 platform. The goal is to thoroughly explore and document the mechanisms involved in facilitating data messaging between Ethereum (Layer 1) and Scroll (Layer 2) on the Scroll L2 platform.

### Brief Introduction to Scroll

Scroll is a Layer 2 (L2) scaling solution built on top of Ethereum, designed specifically as a "zero-knowledge rollup" (zk-Rollup). This means it enhances Ethereum's scalability by processing transactions off-chain while still benefiting from Ethereum's security.

### Overview

The Scroll platform provides a robust framework for data messaging between Ethereum and its L2 environment, focusing on security, efficiency, and compatibility. By leveraging the Scroll Messenger and its layered architecture, developers can build dApps that operate seamlessly across L1 and L2, benefiting from the scalability and reduced costs of the L2 environment while maintaining the security of Ethereum.

The Scroll L2 platform offers an advanced mechanism for data messaging and asset transfer between `L1 (Ethereum)` and `L2 (Scroll)`. This system is crucial for enabling decentralized applications (dApps) to operate seamlessly across these layers, ensuring secure and efficient communication.

### Scroll Bridge and Cross-Domain Messaging

The Scroll Bridge is central to transferring data and assets between Ethereum and Scroll. It supports various token standards, including ETH, ERC20 tokens, ERC721 (NFTs), and ERC1155 tokens.

To facilitate the transfer of ETH and ERC20 tokens, the bridge operates using specialized contracts like `GatewayRouter` for tokens and `L1ScrollMessenger` for arbitrary data transfers. These contracts append messages to a queue, ensuring their inclusion in the L2 chain through a sophisticated cross-domain messaging system. This contract ensures the smooth passage of these assets between L1 and L2, allowing users to transfer their Ethereum-based tokens seamlessly. For more information, refer to [Scroll Docs](https://docs.scroll.io/en/developers/l1-and-l2-bridging/****).

### Gateway Architecture

The Scroll platform distinguishes between L1 and L2 gateway architectures. Both layers have similar permissionless entry points, but the L2 side additionally incorporates a binary Merkle tree (withdraw tree) to store messages. The messages are relayed to the L1 side, where they are verified and processed by the `L1ScrollMessenger`. This architecture ensures that cross-layer transactions are secure and finalized on Ethereum, leveraging the settlement and sequencing layers of Scroll.

#### L1 Gateway Architecture

There are many entry points for users to access the Scroll bridge, depending on the type of asset or data they wish to transfer between Layer 1 (Ethereum) and Layer 2 (Scroll). Here's a breakdown of the different gateways and their functions:

- **GatewayRouter for ETH and ERC20 Tokens**:
  - If you want to transfer ETH or ERC20 tokens from Ethereum (L1) to Scroll (L2), you should use the `GatewayRouter`. This contract is responsible for routing token transfers through the appropriate channels to ensure they are correctly processed and appended to the L2 chain. It serves as the main entry point for standard token transactions.

- **L1ERC721Gateway and L1ERC1155Gateway for NFTs**:
  - For transferring NFTs, the Scroll platform provides specific gateways: `L1ERC721Gateway` for ERC721 tokens (standard NFTs) and `L1ERC1155Gateway` for ERC1155 tokens (multi-token NFTs). These gateways handle the unique requirements of NFT transfers, ensuring that the metadata and ownership details are preserved during the cross-chain operation.

- **L1ScrollMessenger for Arbitrary Data**:
  - When you need to send arbitrary data between L1 and L2, the `L1ScrollMessenger` is the appropriate entry point. This contract is designed to handle non-token data transfers, facilitating the messaging of complex data structures or interactions between smart contracts on Ethereum and Scroll.

- **Scroll Messenger and Message Queue**:
  - Regardless of the type of asset or data being transferred, all gateway operations utilize the Scroll Messenger. The Scroll Messenger's role is to append each transaction to the Message Queue. This queue is then processed to ensure that the transactions are included in the L2 chain, allowing them to be executed and settled on Scroll. This process ensures that all cross-chain transfers are secure, ordered, and recorded appropriately.

  As shown in the figure below, this is the L1 Gateway Architecture:

 <img src="./Images/L1%20Gateway%20Architecture.png" alt="L2 Gateway Architecture" width="500"/>
  
#### L2 Gateway Architecture

Regarding possible permissionlessly callable entry points, the L2 Gateway Architecture is very similar to L1. The difference is that when sending a message from L2, calling the `appendMessage` function will store the message in an append-only binary Merkle tree (also known as the withdraw tree) in the `L2MessageQueue`. When a new message is sent to the `L2MessageQueue`, the relayer will detect it and store it in the database. When the block is finalized, it will generate a proof of the new Merkle path and pass it to the L1geth node to execute on `L1ScrollMessenger`. All finalized withdraw roots will be stored in the rollup contract so we can verify the proof against them. In future Scroll versions, the relayer won’t be needed since all users will be able to finalize the transaction on L1.

As shown in the figure below, this is the L2 Gateway Architecture:

<img src="./Images/L2%20Gateway%20Architecture.png" alt="L2 Gateway Architecture" width="500" />


### Settlement, Sequencing, and Proving Layers

Scroll's architecture is composed of three key layers:

- **Settlement Layer**: The Settlement Layer provides data availability and ordering for the canonical Scroll chain, verifies validity proofs, and allows users and dApps to send messages and assets between Ethereum and Scroll. Ethereum is used as the Settlement Layer, where the bridge and rollup contracts are deployed.

- **Sequencing Layer**: The Sequencing Layer in Scroll is responsible for executing transactions submitted to the network. It processes raw transaction data according to Ethereum Virtual Machine (EVM) rules, producing Layer 2 (L2) blocks that contain the executed transactions and their outcomes, similar to how Ethereum confirms transactions on Layer 1 (L1).

  To optimize efficiency and reduce costs, the Sequencing Layer batches multiple transactions into a single rollup, which is then posted to Ethereum in a compressed form. This batch includes transaction summaries and proof of correct execution, ensuring that all necessary information is available on Ethereum for transparency and security.

- **Proving Layer**: The Proving Layer consists of a pool of provers that generate the zkEVM validity proofs, which verify the correctness of L2 transactions. A coordinator dispatches proving tasks to provers and relays the proofs to the Rollup Node to finalize on Ethereum. For more information, refer to [Scroll Docs](https://docs.scroll.io/en/technology/).

As shown in the figure below, the Scroll chain consists of three layers:

<img src="./Images/scroll%20chain%20layers.png" alt="Scroll Chain Layers" width="500"/>