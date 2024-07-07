# ScrollWorldID
[Git Source](https://github.com/SwineCoder101/world-id-state-bridge/blob/da63ea15118c125576858d5f20d9bfdd91cb337f/src/ScrollWorldID.sol)

**Inherits:**
[WorldIDBridge](/src/abstract/WorldIDBridge.sol/abstract.WorldIDBridge.md), [ScrollCrossDomainOwnable](/src/ScrollCrossDomainOwnable.sol/abstract.ScrollCrossDomainOwnable.md), [IScrollWorldID](/src/interfaces/IScrollWorldID.sol/interface.IScrollWorldID.md)

**Author:**
Worldcoin

A contract that manages the root history of the Semaphore identity merkle tree on
Scroll.

*This contract is deployed on Optimism and is called by the L1 Proxy contract for each new
root insertion.*


## Functions
### constructor

CONSTRUCTION                             ///

Initializes the contract the depth of the associated merkle tree.


```solidity
constructor(uint8 _treeDepth) WorldIDBridge(_treeDepth);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_treeDepth`|`uint8`|The depth of the WorldID Semaphore merkle tree.|


### receiveRoot

ROOT MIRRORING                            ///

This function is called by the state bridge contract when it forwards a new root to
the bridged WorldID.

*This function can revert if Scroll's ScrollMessenger stops processing proofs*


```solidity
function receiveRoot(uint256 newRoot) external virtual onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`newRoot`|`uint256`|The value of the new root.|


### setRootHistoryExpiry

DATA MANAGEMENT                            ///

Sets the amount of time it takes for a root in the root history to expire.


```solidity
function setRootHistoryExpiry(uint256 expiryTime) public virtual override onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`expiryTime`|`uint256`|The new amount of time it takes for a root to expire.|


