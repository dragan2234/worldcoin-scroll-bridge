The investigations outline the creation of a service or sequencer that periodically updates the Merkle tree root. Here’s a quick summary of how the described components and steps relate to this:

1. **Understanding Components**:
   - **World ID Merkle Tree**: The structure that maintains user identity proofs.
   - **State Bridge Contracts**: Facilitate communication between L1 and L2.

2. **Key Requirements**:
   - **Service to Sync Merkle Tree**: The core service or sequencer that handles periodic updates.
   - **EVM Compatibility**: Ensures the L2 blockchain can support necessary operations.
   - **L1<>L2 Messaging Layer**: For transferring updates between L1 and L2.
   - **Relayer Service**: Automates the process of updating the Merkle tree root on the L2.

3. **Implementation Steps**:
   - **Setting Up Contracts**: Deploy contracts on both L1 and L2 to manage and propagate the Merkle tree root.
   - **Synchronizing the Merkle Tree**: Implement the logic to fetch the latest root and propagate it to L2.
   - **Setting Up a Relayer Service**: Automate periodic updates with scheduling tools.
   - **Building a Merkle Tree Explorer (Optional)**: For visualizing and managing the Merkle tree data.

The goal is to create a system that fetches the latest Merkle tree root from the World ID system and updates it on the target L2 network, ensuring that the identity verification remains accurate and up-to-date across different blockchain layers.