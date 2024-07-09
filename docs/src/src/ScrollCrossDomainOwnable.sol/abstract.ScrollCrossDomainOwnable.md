# ScrollCrossDomainOwnable
[Git Source](https://github.com/SwineCoder101/world-id-state-bridge/blob/da63ea15118c125576858d5f20d9bfdd91cb337f/src/ScrollCrossDomainOwnable.sol)

**Inherits:**
Ownable

**Author:**
Worldcoin, OPLabsPBC

This contract extends the OpenZeppelin `Ownable` contract for L2 contracts to be owned
by contracts on either L1 or L2. Note that this contract is meant to be used with
systems that use the ScrollMessenger system.

*Fork of CrossDomainOwnable3 from @eth-optimism/contracts-bedrock/contracts/L2/CrossDomainOwnable3*


## State Variables
### scrollMessengerAddress
The L2ScrollMessenger is used to check whether a call is coming from L1.

*Sepolia address on Scroll for the L2ScrollMessenger:
https://docs.scroll.io/en/developers/scroll-contracts/*


```solidity
address scrollMessengerAddress = address(0xBa50f5340FB9F3Bd074bD638c9BE13eCB36E603d);
```


### messenger

```solidity
IL2ScrollMessenger public messenger = IL2ScrollMessenger(scrollMessengerAddress);
```


### isLocal
If true, the contract uses the cross domain _checkOwner function override.
If false it uses the standard Ownable _checkOwner function.


```solidity
bool public isLocal = true;
```


## Functions
### transferOwnership

Allows for ownership to be transferred with specifying the locality.


```solidity
function transferOwnership(address _owner, bool _isLocal) external onlyOwner;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_owner`|`address`|  The new owner of the contract.|
|`_isLocal`|`bool`|Configures the locality of the ownership.|


### _checkOwner

Overrides the implementation of the `onlyOwner` modifier to check that the unaliased
`xDomainMessageSender` is the owner of the contract. This value is set to the caller
of the L1ScrollMessenger.


```solidity
function _checkOwner() internal view override;
```

## Events
### OwnershipTransferred
Emits when ownership of the contract is transferred. Includes the
isLocal field in addition to the standard `Ownable` OwnershipTransferred event.


```solidity
event OwnershipTransferred(address indexed previousOwner, address indexed newOwner, bool isLocal);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`previousOwner`|`address`|The previous owner of the contract.|
|`newOwner`|`address`|     The new owner of the contract.|
|`isLocal`|`bool`|      Configures the `isLocal` contract variable.|

