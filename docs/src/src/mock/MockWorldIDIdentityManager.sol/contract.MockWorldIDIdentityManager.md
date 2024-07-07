# MockWorldIDIdentityManager
[Git Source](https://github.com/SwineCoder101/world-id-state-bridge/blob/da63ea15118c125576858d5f20d9bfdd91cb337f/src/mock/MockWorldIDIdentityManager.sol)

**Inherits:**
[IWorldIDIdentityManager](/src/interfaces/IWorldIDIdentityManager.sol/interface.IWorldIDIdentityManager.md)

**Author:**
Worldcoin

Mock of the WorldID Identity Manager contract (world-id-contracts) to test functionality on a local chain

*deployed through make mock and make local-mock*


## State Variables
### _latestRoot

```solidity
uint256 internal _latestRoot;
```


## Functions
### constructor


```solidity
constructor(uint256 initRoot);
```

### registerIdentities

Registers identities into the WorldID system.

*Can only be called by the identity operator.*

*Registration is performed off-chain and verified on-chain via the `insertionProof`.
This saves gas and time over inserting identities one at a time.*


```solidity
function registerIdentities(
    uint256[8] calldata insertionProof,
    uint256 preRoot,
    uint32 startIndex,
    uint256[] calldata identityCommitments,
    uint256 postRoot
) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`insertionProof`|`uint256[8]`|The proof that given the conditions (`preRoot`, `startIndex` and `identityCommitments`), insertion into the tree results in `postRoot`. Elements 0 and 1 are the `x` and `y` coordinates for `ar` respectively. Elements 2 and 3 are the `x` coordinate for `bs`, and elements 4 and 5 are the `y` coordinate for `bs`. Elements 6 and 7 are the `x` and `y` coordinates for `krs`.|
|`preRoot`|`uint256`|The value for the root of the tree before the `identityCommitments` have been|
|`startIndex`|`uint32`|The position in the tree at which the insertions were made.|
|`identityCommitments`|`uint256[]`|The identities that were inserted into the tree starting at `startIndex` and `preRoot` to give `postRoot`. All of the commitments must be elements of the field `Kr`.|
|`postRoot`|`uint256`|The root obtained after inserting all of `identityCommitments` into the tree described by `preRoot`. Must be an element of the field `Kr`. (alread in reduced form)|


### deleteIdentities

Deletes identities from the WorldID system.

*Can only be called by the identity operator.*

*Deletion is performed off-chain and verified on-chain via the `deletionProof`.
This saves gas and time over deleting identities one at a time.*


```solidity
function deleteIdentities(
    uint256[8] calldata deletionProof,
    bytes calldata packedDeletionIndices,
    uint256 preRoot,
    uint256 postRoot
) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`deletionProof`|`uint256[8]`|The proof that given the conditions (`preRoot` and `packedDeletionIndices`), deletion into the tree results in `postRoot`. Elements 0 and 1 are the `x` and `y` coordinates for `ar` respectively. Elements 2 and 3 are the `x` coordinate for `bs`, and elements 4 and 5 are the `y` coordinate for `bs`. Elements 6 and 7 are the `x` and `y` coordinates for `krs`.|
|`packedDeletionIndices`|`bytes`|The indices of the identities that were deleted from the tree. The batch size is inferred from the length of this|
|`preRoot`|`uint256`|The value for the root of the tree before the corresponding identity commitments have been deleted. Must be an element of the field `Kr`.|
|`postRoot`|`uint256`|The root obtained after deleting all of `identityCommitments` into the tree described by `preRoot`. Must be an element of the field `Kr`.|


### insertRoot


```solidity
function insertRoot(uint256 postRoot) public;
```

### latestRoot


```solidity
function latestRoot() external view returns (uint256);
```

## Events
### TreeChanged
Emitted when the current root of the tree is updated.


```solidity
event TreeChanged(uint256 indexed preRoot, TreeChange indexed kind, uint256 indexed postRoot);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`preRoot`|`uint256`|The value of the tree's root before the update.|
|`kind`|`TreeChange`|Either "insertion" or "update", the kind of alteration that was made to the tree.|
|`postRoot`|`uint256`|The value of the tree's root after the update.|

## Enums
### TreeChange
Represents the kind of change that is made to the root of the tree.


```solidity
enum TreeChange {
    Insertion,
    Deletion
}
```

