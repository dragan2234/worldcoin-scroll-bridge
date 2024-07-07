# MockPolygonBridge
[Git Source](https://github.com/SwineCoder101/world-id-state-bridge/blob/da63ea15118c125576858d5f20d9bfdd91cb337f/src/mock/MockPolygonBridge.sol)

**Inherits:**
[WorldIDBridge](/src/abstract/WorldIDBridge.sol/abstract.WorldIDBridge.md), Ownable

**Author:**
Worldcoin

*of the Polygon FxPortal Bridge to test low-level assembly functions
`grabSelector` and `stripSelector` in the PolygonWorldID contract*


## State Variables
### _receiveRootSelector
The selector of the `receiveRoot` function.

*this selector is precomputed in the constructor to not have to recompute them for every
call of the _processMesageFromRoot function*


```solidity
bytes4 internal _receiveRootSelector;
```


### _receiveRootHistoryExpirySelector
The selector of the `receiveRootHistoryExpiry` function.

*this selector is precomputed in the constructor to not have to recompute them for every
call of the _processMesageFromRoot function*


```solidity
bytes4 internal _receiveRootHistoryExpirySelector;
```


## Functions
### constructor

Initializes the contract's storage variables with the correct parameters


```solidity
constructor(uint8 _treeDepth) WorldIDBridge(_treeDepth);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_treeDepth`|`uint8`|The depth of the WorldID Identity Manager merkle tree.|


### processMessageFromRoot

ROOT MIRRORING                            ///

Mock for Polygon's FxPortal bridge functionality


```solidity
function processMessageFromRoot(bytes memory message) public onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`message`|`bytes`|An ABI-encoded tuple of `(uint256 newRoot, uint128 supersedeTimestamp)` that is used to call `receiveRoot`.|


### setRootHistoryExpiry

DATA MANAGEMENT                            ///

Placeholder to satisfy WorldIDBridge inheritance

*This function is not used on Polygon PoS because of FxPortal message passing architecture*


```solidity
function setRootHistoryExpiry(uint256) public virtual override;
```

## Errors
### InvalidMessageSelector
Emitted when the message selector passed from FxRoot is invalid.


```solidity
error InvalidMessageSelector(bytes4 selector);
```

