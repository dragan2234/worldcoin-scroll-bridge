# WorldIDBridge
[Git Source](https://github.com/SwineCoder101/world-id-state-bridge/blob/da63ea15118c125576858d5f20d9bfdd91cb337f/src/abstract/WorldIDBridge.sol)

**Inherits:**
[IWorldID](/src/interfaces/IWorldID.sol/interface.IWorldID.md)

**Author:**
Worldcoin

A base contract for the WorldID state bridges that exist on other chains. The state
bridges manage the root history of the identity merkle tree on chains other than
mainnet.

*This contract abstracts the common functionality, allowing for easier understanding and
code reuse.*

*This contract is very explicitly not able to be instantiated. Do not un-mark it as
`abstract`.*


## State Variables
### treeDepth
CONTRACT DATA                              ///

The depth of the merkle tree used to store identities.


```solidity
uint8 internal immutable treeDepth;
```


### ROOT_HISTORY_EXPIRY
The amount of time a root is considered as valid on the bridged chain.


```solidity
uint256 internal ROOT_HISTORY_EXPIRY = 1 weeks;
```


### _latestRoot
The value of the latest merkle tree root.


```solidity
uint256 internal _latestRoot;
```


### rootHistory
The mapping between the value of the merkle tree root and the timestamp at which it
entered the root history.


```solidity
mapping(uint256 => uint128) public rootHistory;
```


### NULL_ROOT_TIME
The time in the `rootHistory` mapping associated with a root that has never been
seen before.


```solidity
uint128 internal constant NULL_ROOT_TIME = 0;
```


### semaphoreVerifier
The verifier instance needed to operate within the semaphore protocol.


```solidity
SemaphoreVerifier internal semaphoreVerifier = new SemaphoreVerifier();
```


## Functions
### constructor

CONSTRUCTION                              ///

Constructs a new instance of the state bridge.


```solidity
constructor(uint8 _treeDepth);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_treeDepth`|`uint8`|The depth of the identities merkle tree.|


### _receiveRoot

ROOT MIRRORING                             ///

This function is called by the state bridge contract when it forwards a new root to
the bridged WorldID.

*Intended to be called from a privilege-checked implementation of `receiveRoot` or an
equivalent operation.*


```solidity
function _receiveRoot(uint256 newRoot) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`newRoot`|`uint256`|The value of the new root.|


### requireValidRoot

Reverts if the provided root value is not valid.

*A root is valid if it is either the latest root, or not the latest root but has not
expired.*


```solidity
function requireValidRoot(uint256 root) internal view;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`root`|`uint256`|The root of the merkle tree to check for validity.|


### verifyProof

SEMAPHORE PROOFS                            ///

A verifier for the semaphore protocol.

*Note that a double-signaling check is not included here, and should be carried by the
caller.*


```solidity
function verifyProof(
    uint256 root,
    uint256 signalHash,
    uint256 nullifierHash,
    uint256 externalNullifierHash,
    uint256[8] calldata proof
) public view virtual;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`root`|`uint256`|The root of the Merkle tree|
|`signalHash`|`uint256`|A keccak256 hash of the Semaphore signal|
|`nullifierHash`|`uint256`|The nullifier hash|
|`externalNullifierHash`|`uint256`|A keccak256 hash of the external nullifier|
|`proof`|`uint256[8]`|The zero-knowledge proof|


### latestRoot

DATA MANAGEMENT                            ///

Gets the value of the latest root.


```solidity
function latestRoot() public view virtual returns (uint256);
```

### rootHistoryExpiry

Gets the amount of time it takes for a root in the root history to expire.


```solidity
function rootHistoryExpiry() public view virtual returns (uint256);
```

### setRootHistoryExpiry

Sets the amount of time it takes for a root in the root history to expire.

*When implementing this function, ensure that it is guarded on `onlyOwner`.*


```solidity
function setRootHistoryExpiry(uint256 expiryTime) public virtual;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`expiryTime`|`uint256`|The new amount of time it takes for a root to expire.|


### _setRootHistoryExpiry

Sets the amount of time it takes for a root in the root history to expire.

*Intended to be called from a privilege-checked implementation of `receiveRoot`.*


```solidity
function _setRootHistoryExpiry(uint256 expiryTime) internal virtual;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`expiryTime`|`uint256`|The new amount of time it takes for a root to expire.|


### getTreeDepth

Gets the Semaphore tree depth the contract was initialized with.


```solidity
function getTreeDepth() public view virtual returns (uint8);
```

## Events
### RootAdded
EVENTS                                 ///

Emitted when a new root is received by the contract.


```solidity
event RootAdded(uint256 root, uint128 timestamp);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`root`|`uint256`|The value of the root that was added.|
|`timestamp`|`uint128`|The timestamp of insertion for the given root.|

### RootHistoryExpirySet
Emitted when the expiry time for the root history is updated.


```solidity
event RootHistoryExpirySet(uint256 newExpiry);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`newExpiry`|`uint256`|The new expiry time.|

## Errors
### UnsupportedTreeDepth
ERRORS                                 ///

Emitted when the provided semaphore tree depth is unsupported.


```solidity
error UnsupportedTreeDepth(uint8 depth);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`depth`|`uint8`|The tree depth that was passed.|

### ExpiredRoot
Emitted when attempting to validate a root that has expired.


```solidity
error ExpiredRoot();
```

### NonExistentRoot
Emitted when attempting to validate a root that has yet to be added to the root
history.


```solidity
error NonExistentRoot();
```

### CannotOverwriteRoot
Emitted when attempting to update the timestamp for a root that already has one.


```solidity
error CannotOverwriteRoot();
```

### NoRootsSeen
Emitted if the latest root is requested but the bridge has not seen any roots yet.


```solidity
error NoRootsSeen();
```

