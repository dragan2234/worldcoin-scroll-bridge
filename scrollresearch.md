Research on the key aspects of sending data between Ethereum L1 and the Scroll L2 network:

## Sending Data Between Ethereum L1 and Scroll L2

The process for sending data between Ethereum L1 and the Scroll L2 network involves a pair of special "messenger" smart contracts that abstract away the lower-level communication details.

****Sending from L1 to L2****
1. The L1 contract calls the `L1ScrollMessenger` contract, which then sends a message to the `OptimismPortal` contract on L2.
2. This L1 to L2 transaction incurs gas costs on Ethereum, which are determined by the current gas prices. The L2 execution also triggers a dynamic gas burn on L1 to pay for the L2 computation .

****Sending from L2 to L1****
1. The L2 contract initiates the transaction, which is priced like any other L2 transaction .
2. An L1 transaction is then required to "prove" the L2 transaction, by verifying a Merkle inclusion proof on-chain. This L1 proof transaction is expensive. 
3. Finally, an L1 "finalization" transaction is needed after the challenge period (7 days on mainnet) to complete the L2 to L1 message .

The total cost of an L2 to L1 message is the sum of the L2 initiation and the two expensive L1 proof and finalization transactions.

Scroll aims to provide a secure, low-cost, and developer-friendly L2 execution environment that is EVM-equivalent, allowing seamless migration of Ethereum-based applications .

The technical architecture includes a centralized sequencer, a decentralized proving network, and a set of privileged roles that require careful management .
