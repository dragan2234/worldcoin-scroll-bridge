# IWorldID
[Git Source](https://github.com/SwineCoder101/world-id-state-bridge/blob/da63ea15118c125576858d5f20d9bfdd91cb337f/src/interfaces/IWorldID.sol)

**Author:**
Worldcoin

The interface to the Semaphore Groth16 proof verification for WorldID.


## Functions
### verifyProof

Verifies a WorldID zero knowledge proof.

*Note that a double-signaling check is not included here, and should be carried by the
caller.*

*It is highly recommended that the implementation is restricted to `view` if possible.*


```solidity
function verifyProof(
    uint256 root,
    uint256 signalHash,
    uint256 nullifierHash,
    uint256 externalNullifierHash,
    uint256[8] calldata proof
) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`root`|`uint256`|The of the Merkle tree|
|`signalHash`|`uint256`|A keccak256 hash of the Semaphore signal|
|`nullifierHash`|`uint256`|The nullifier hash|
|`externalNullifierHash`|`uint256`|A keccak256 hash of the external nullifier|
|`proof`|`uint256[8]`|The zero-knowledge proof|


