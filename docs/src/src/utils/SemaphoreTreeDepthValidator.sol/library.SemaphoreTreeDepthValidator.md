# SemaphoreTreeDepthValidator
[Git Source](https://github.com/SwineCoder101/world-id-state-bridge/blob/da63ea15118c125576858d5f20d9bfdd91cb337f/src/utils/SemaphoreTreeDepthValidator.sol)

**Author:**
Worldcoin


## Functions
### validate

Checks if the provided `treeDepth` is among supported depths.


```solidity
function validate(uint8 treeDepth) internal pure returns (bool supportedDepth);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`treeDepth`|`uint8`|The tree depth to validate.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`supportedDepth`|`bool`|Returns `true` if `treeDepth` is between 16 and 32|


