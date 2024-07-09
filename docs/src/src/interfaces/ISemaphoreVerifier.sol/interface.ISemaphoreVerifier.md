# ISemaphoreVerifier
[Git Source](https://github.com/SwineCoder101/world-id-state-bridge/blob/da63ea15118c125576858d5f20d9bfdd91cb337f/src/interfaces/ISemaphoreVerifier.sol)

**Author:**
Worldcoin

An interface representing a merkle tree verifier.


## Functions
### verifyProof

Verify an uncompressed Groth16 proof.

Reverts with InvalidProof if the proof is invalid or
with PublicInputNotInField the public input is not reduced.

There is no return value. If the function does not revert, the
proof was succesfully verified.


```solidity
function verifyProof(uint256[8] calldata proof, uint256[4] calldata input) external view;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`proof`|`uint256[8]`|the points (A, B, C) in EIP-197 format matching the output of compressProof.|
|`input`|`uint256[4]`|the public input field elements in the scalar field Fr. Elements must be reduced.|


