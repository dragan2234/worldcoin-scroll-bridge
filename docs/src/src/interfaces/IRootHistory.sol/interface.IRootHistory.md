# IRootHistory
[Git Source](https://github.com/SwineCoder101/world-id-state-bridge/blob/da63ea15118c125576858d5f20d9bfdd91cb337f/src/interfaces/IRootHistory.sol)

**Author:**
Worldcoin

Interface for WorldID setRooHistoryExpiry

*Used in StateBridge to set the root history expiry time on Optimism (OPWorldID)*


## Functions
### setRootHistoryExpiry

Sets the amount of time it takes for a root in the root history to expire.


```solidity
function setRootHistoryExpiry(uint256 expiryTime) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`expiryTime`|`uint256`|The new amount of time it takes for a root to expire.|


