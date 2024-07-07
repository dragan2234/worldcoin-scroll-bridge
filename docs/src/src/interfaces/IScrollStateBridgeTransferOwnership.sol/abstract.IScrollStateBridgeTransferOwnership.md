# IScrollStateBridgeTransferOwnership
[Git Source](https://github.com/SwineCoder101/world-id-state-bridge/blob/da63ea15118c125576858d5f20d9bfdd91cb337f/src/interfaces/IScrollStateBridgeTransferOwnership.sol)

Interface for the StateBridge to transfer ownership
of ScrollWorldID to another contract on L1 or to a Scroll EOA or contract

*This is a subset of the ScrollStateBridge contract*


## Functions
### transferOwnershipScroll

Adds functionality to the StateBridge to transfer ownership
of ScrollWorldID to another contract on L1 or to a Scroll chain EOA


```solidity
function transferOwnershipScroll(address _owner, bool _isLocal) external virtual;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_owner`|`address`|new owner (EOA or contract)|
|`_isLocal`|`bool`|true if new owner is on Scroll, false if it is a cross-domain owner|


