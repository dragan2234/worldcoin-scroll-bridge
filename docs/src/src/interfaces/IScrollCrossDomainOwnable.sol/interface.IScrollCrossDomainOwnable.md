# IScrollCrossDomainOwnable
[Git Source](https://github.com/SwineCoder101/world-id-state-bridge/blob/da63ea15118c125576858d5f20d9bfdd91cb337f/src/interfaces/IScrollCrossDomainOwnable.sol)

**Author:**
Worldcoin

Interface for the CrossDomainOwnable contract for the Scroll L2

*Adds functionality to the StateBridge to transfer ownership
of ScrollWorldID to another contract on L1 or to a local Scroll EOA or contract*


## Functions
### transferOwnership

transfers owner to a cross-domain or local owner


```solidity
function transferOwnership(address _owner, bool _isLocal) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_owner`|`address`|new owner (EOA or contract)|
|`_isLocal`|`bool`|true if new owner is on Optimism, false if it is a cross-domain owner|


