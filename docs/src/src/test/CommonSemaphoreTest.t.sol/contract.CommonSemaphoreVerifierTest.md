# CommonSemaphoreVerifierTest
[Git Source](https://github.com/SwineCoder101/world-id-state-bridge/blob/da63ea15118c125576858d5f20d9bfdd91cb337f/src/test/CommonSemaphoreTest.t.sol)

**Inherits:**
PRBTest

**Author:**
Worldcoin

A contract that generates the shared test cases for the SemaphoreVerifier contract.


## State Variables
### verifier
CONTRACT DATA                              ///

The SemaphoreVerifier contract to test.


```solidity
SemaphoreVerifier internal verifier;
```


### inclusionRoot
INCLUSION                          ///

*generated using https://github.com/worldcoin/semaphore-mock
steps:
1. cargo run --release generate-identities --identities 10
2. cargo run --release prove-inclusion --identities out/random_identities.json --tree-depth 16 --identity-index 3*

*params from `src/test/data/InclusionProof.json` (output of step 2.)*


```solidity
uint256 internal constant inclusionRoot =
    0xdf9f0cb5a3afe2129e349c1435bfbe9e6f091832fdfa7b739b61c5db2cbdde9;
```


### inclusionSignalHash

```solidity
uint256 internal constant inclusionSignalHash =
    0xbc6bb462e38af7da48e0ae7b5cbae860141c04e5af2cf92328cd6548df111f;
```


### inclusionNullifierHash

```solidity
uint256 internal constant inclusionNullifierHash =
    0x2887375654a2f83868b277f3836678aa55475fd5c840b117913ea4a7c9ded6fc;
```


### inclusionExternalNullifierHash

```solidity
uint256 internal constant inclusionExternalNullifierHash =
    0xfd3a1e9736c12a5d4a31f26362b577ccafbd523d358daf40cdc04d90e17f77;
```


### inclusionProof

```solidity
uint256[8] inclusionProof;
```


## Functions
### constructor


```solidity
constructor();
```

### testValidProof

Tests that Semaphore proofs verify correctly.

*generated using https://github.com/worldcoin/semaphore-mock
steps:
1. cargo run --release generate-identities --identities 10
2. cargo run --release prove-inclusion --identities out/random_identities.json --tree-depth 16 --identity-index 3
TEST CASES                                ///*


```solidity
function testValidProof() public;
```

### testInvalidProof

Tests that invalid Semaphore proofs revert


```solidity
function testInvalidProof(uint256[8] calldata proof, uint256[4] calldata input) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`proof`|`uint256[8]`|The proof to test.|
|`input`|`uint256[4]`|The public input to test.|


## Errors
### ProofInvalid
The proof is invalid.

*This can mean that provided Groth16 proof points are not on their
curves, that pairing equation fails, or that the proof is not for the
provided public input.*


```solidity
error ProofInvalid();
```

