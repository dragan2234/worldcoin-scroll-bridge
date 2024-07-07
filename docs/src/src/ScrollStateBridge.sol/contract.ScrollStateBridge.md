# ScrollStateBridge
[Git Source](https://github.com/SwineCoder101/world-id-state-bridge/blob/da63ea15118c125576858d5f20d9bfdd91cb337f/src/ScrollStateBridge.sol)

**Inherits:**
Ownable2Step

**Author:**
Worldcoin

Distributes new World ID Identity Manager roots to Scroll


## State Variables
### scrollWorldIDAddress
STORAGE                           ///

The address of the ScrollWorldID contract


```solidity
address public immutable scrollWorldIDAddress;
```


### scrollMessengerAddress
address for the Scroll Messenger contract on Ethereum


```solidity
address internal immutable scrollMessengerAddress;
```


### worldIDAddress
Ethereum World ID Identity Manager Address


```solidity
address public immutable worldIDAddress;
```


### _gasLimitPropagateRoot
Amount of gas purchased on Scroll for propagateRoot


```solidity
uint32 internal _gasLimitPropagateRoot;
```


### _gasLimitSetRootHistoryExpiry
Amount of gas purchased on Scroll for SetRootHistoryExpiry


```solidity
uint32 internal _gasLimitSetRootHistoryExpiry;
```


### _gasLimitTransferOwnership
Amount of gas purchased on Scroll for transferOwnershipScroll


```solidity
uint32 internal _gasLimitTransferOwnership;
```


### DEFAULT_SCROLL_GAS_LIMIT
The default gas limit amount to buy on Scroll


```solidity
uint32 public constant DEFAULT_SCROLL_GAS_LIMIT = 1000000;
```


## Functions
### constructor

CONSTRUCTOR                         ///

constructor


```solidity
constructor(
    address _worldIDIdentityManager,
    address _scrollWorldIDAddress,
    address _scrollMessengerAddress
);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_worldIDIdentityManager`|`address`|Deployment address of the WorldID Identity Manager contract|
|`_scrollWorldIDAddress`|`address`|Address of the Scroll contract that will receive the new root and timestamp|
|`_scrollMessengerAddress`|`address`|Scroll Messenger address on Ethereum|


### propagateRoot

PUBLIC API                         ///

Sends the latest WorldID Identity Manager root to Scroll

*Calls this method on the L1 Proxy contract to relay roots to Scroll*


```solidity
function propagateRoot() external;
```

### transferOwnershipScroll

Adds functionality to the StateBridge to transfer ownership
of ScrollWorldID to another contract on L1 or to a local Scroll EOA


```solidity
function transferOwnershipScroll(address _owner, bool _isLocal) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_owner`|`address`|new owner (EOA or contract)|
|`_isLocal`|`bool`|true if new owner is on Scroll, false if it is a cross-domain owner|


### setRootHistoryExpiry

Adds functionality to the StateBridge to set the root history expiry on ScrollWorldID


```solidity
function setRootHistoryExpiry(uint256 _rootHistoryExpiry) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_rootHistoryExpiry`|`uint256`|new root history expiry|


### setGasLimitPropagateRoot

SCROLL GAS LIMIT                      ///

Sets the gas limit for the propagateRoot method


```solidity
function setGasLimitPropagateRoot(uint32 _scrollGasLimit) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_scrollGasLimit`|`uint32`|The new gas limit for the propagateRoot method|


### setGasLimitSetRootHistoryExpiry

Sets the gas limit for the SetRootHistoryExpiry method


```solidity
function setGasLimitSetRootHistoryExpiry(uint32 _scrollGasLimit) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_scrollGasLimit`|`uint32`|The new gas limit for the SetRootHistoryExpiry method|


### setGasLimitTransferOwnershipScroll

Sets the gas limit for the transferOwnershipScroll method


```solidity
function setGasLimitTransferOwnershipScroll(uint32 _scrollGasLimit) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_scrollGasLimit`|`uint32`|The new gas limit for the transferOwnershipScroll method|


### renounceOwnership

OWNERSHIP                          ///

Ensures that ownership of WorldID implementations cannot be renounced.

*This function is intentionally not `virtual` as we do not want it to be possible to
renounce ownership for any WorldID implementation.*

*This function is marked as `onlyOwner` to maintain the access restriction from the base
contract.*


```solidity
function renounceOwnership() public view override onlyOwner;
```

## Events
### OwnershipTransferredScroll
EVENTS                           ///

Emitted when the StateBridge gives ownership of the ScrollWorldID contract
to the WorldID Identity Manager contract away


```solidity
event OwnershipTransferredScroll(
    address indexed previousOwner, address indexed newOwner, bool isLocal
);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`previousOwner`|`address`|The previous owner of the ScrollWorldID contract|
|`newOwner`|`address`|The new owner of the ScrollWorldID contract|
|`isLocal`|`bool`|Whether the ownership transfer is local (Scroll) or an Ethereum EOA or contract|

### RootPropagated
Emitted when the StateBridge sends a root to the ScrollWorldID contract


```solidity
event RootPropagated(uint256 root);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`root`|`uint256`|The root sent to the ScrollWorldID contract on Scroll|

### SetRootHistoryExpiry
Emitted when the StateBridge sets the root history expiry for ScrollWorldID and PolygonWorldID


```solidity
event SetRootHistoryExpiry(uint256 rootHistoryExpiry);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`rootHistoryExpiry`|`uint256`|The new root history expiry|

### SetGasLimitPropagateRoot
Emitted when the StateBridge sets the gas limit for sendRootScroll


```solidity
event SetGasLimitPropagateRoot(uint32 _scrollGasLimit);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_scrollGasLimit`|`uint32`|The new scrollGasLimit for sendRootScroll|

### SetGasLimitSetRootHistoryExpiry
Emitted when the StateBridge sets the gas limit for SetRootHistoryExpiry


```solidity
event SetGasLimitSetRootHistoryExpiry(uint32 _scrollGasLimit);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_scrollGasLimit`|`uint32`|The new scrollGasLimit for SetRootHistoryExpiry|

### SetGasLimitTransferOwnershipScroll
Emitted when the StateBridge sets the gas limit for transferOwnershipScroll


```solidity
event SetGasLimitTransferOwnershipScroll(uint32 _scrollGasLimit);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_scrollGasLimit`|`uint32`|The new scrollGasLimit for transferOwnershipScroll|

## Errors
### CannotRenounceOwnership
ERRORS                           ///

Emitted when an attempt is made to renounce ownership.


```solidity
error CannotRenounceOwnership();
```

### GasLimitZero
Emitted when an attempt is made to set the gas limit to zero


```solidity
error GasLimitZero();
```

### AddressZero
Emitted when an attempt is made to set an address to zero


```solidity
error AddressZero();
```

