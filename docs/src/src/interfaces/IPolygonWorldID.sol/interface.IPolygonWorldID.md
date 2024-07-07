# IPolygonWorldID
[Git Source](https://github.com/SwineCoder101/world-id-state-bridge/blob/da63ea15118c125576858d5f20d9bfdd91cb337f/src/interfaces/IPolygonWorldID.sol)

**Author:**
Worldcoin

Interface for the CrossDomainOwnable contract for the Optimism L2


## Functions
### receiveRoot

ROOT MIRRORING                            ///

This function is called by the state bridge contract when it forwards a new root to
the bridged WorldID.


```solidity
function receiveRoot(uint256 newRoot) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`newRoot`|`uint256`|The value of the new root.|


