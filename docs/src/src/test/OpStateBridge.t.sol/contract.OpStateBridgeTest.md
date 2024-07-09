# OpStateBridgeTest
[Git Source](https://github.com/SwineCoder101/world-id-state-bridge/blob/da63ea15118c125576858d5f20d9bfdd91cb337f/src/test/OpStateBridge.t.sol)

**Inherits:**
PRBTest, StdCheats

**Author:**
Worldcoin

A test contract for StateBridge.sol


## State Variables
### mainnetFork
STORAGE CONFIG                       ///


```solidity
uint256 public mainnetFork;
```


### MAINNET_RPC_URL

```solidity
string private MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");
```


### opStateBridge

```solidity
OpStateBridge public opStateBridge;
```


### mockWorldID

```solidity
MockWorldIDIdentityManager public mockWorldID;
```


### opGasLimit

```solidity
uint32 public opGasLimit;
```


### mockWorldIDAddress

```solidity
address public mockWorldIDAddress;
```


### owner

```solidity
address public owner;
```


### opWorldIDAddress
The address of the OpWorldID contract on any OP Stack chain


```solidity
address public opWorldIDAddress;
```


### opCrossDomainMessengerAddress
address for OP Stack chain Ethereum mainnet L1CrossDomainMessenger contract


```solidity
address public opCrossDomainMessengerAddress;
```


### sampleRoot

```solidity
uint256 public sampleRoot;
```


## Functions
### setUp


```solidity
function setUp() public;
```

### test_canSelectFork_succeeds

Create a fork of the Ethereum mainnet

Roll the fork to a block where both Optimim's and Base's crossDomainMessenger contract is deployed

and the Base crossDomainMessenger ResolvedDelegateProxy target address is initialized
SUCCEEDS                          ///

select a specific fork


```solidity
function test_canSelectFork_succeeds() public;
```

### test_propagateRoot_suceeds


```solidity
function test_propagateRoot_suceeds() public;
```

### test_owner_transferOwnership_succeeds

Tests that the owner of the StateBridge contract can transfer ownership
using Ownable2Step transferOwnership


```solidity
function test_owner_transferOwnership_succeeds(address newOwner) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`newOwner`|`address`|the new owner of the contract|


### test_owner_transferOwnershipOp_succeeds

tests whether the StateBridge contract can transfer ownership of the OPWorldID contract


```solidity
function test_owner_transferOwnershipOp_succeeds(address newOwner, bool isLocal) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`newOwner`|`address`|The new owner of the OPWorldID contract (foundry fuzz)|
|`isLocal`|`bool`|Whether the ownership transfer is local (Optimism EOA/contract) or an Ethereum EOA or contract|


### test_owner_setRootHistoryExpiry_succeeds

tests whether the StateBridge contract can set root history expiry on Optimism and Polygon


```solidity
function test_owner_setRootHistoryExpiry_succeeds(uint256 _rootHistoryExpiry) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_rootHistoryExpiry`|`uint256`|The new root history expiry for OpWorldID and PolygonWorldID|


### test_owner_setGasLimitPropagateRoot_succeeds

tests whether the StateBridge contract can set the opGasLimit for sendRootOptimism


```solidity
function test_owner_setGasLimitPropagateRoot_succeeds(uint32 _opGasLimit) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_opGasLimit`|`uint32`|The new opGasLimit for sendRootOptimism|


### test_owner_setGasLimitSetRootHistoryExpiry_succeeds

tests whether the StateBridge contract can set the opGasLimit for SetRootHistoryExpirytimism


```solidity
function test_owner_setGasLimitSetRootHistoryExpiry_succeeds(uint32 _opGasLimit) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_opGasLimit`|`uint32`|The new opGasLimit for SetRootHistoryExpirytimism|


### test_owner_setGasLimitTransferOwnershipOp_succeeds

tests whether the StateBridge contract can set the opGasLimit for transferOwnershipOptimism


```solidity
function test_owner_setGasLimitTransferOwnershipOp_succeeds(uint32 _opGasLimit) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_opGasLimit`|`uint32`|The new opGasLimit for transferOwnershipOptimism|


### test_cannotInitializeConstructorWithZeroAddresses_reverts

REVERTS                           ///

Tests that the StateBridge constructor params can't be set to the zero address


```solidity
function test_cannotInitializeConstructorWithZeroAddresses_reverts() public;
```

### test_notOwner_transferOwnership_reverts

tests that the StateBridge contract's ownership can't be changed by a non-owner


```solidity
function test_notOwner_transferOwnership_reverts(address nonOwner, address newOwner) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`nonOwner`|`address`|An address that is not the owner of the StateBridge contract|
|`newOwner`|`address`|The new owner of the StateBridge contract (foundry fuzz)|


### test_owner_transferOwnershipOp_toZeroAddress_reverts

tests that the StateBridge contract's ownership can't be set to be the zero address


```solidity
function test_owner_transferOwnershipOp_toZeroAddress_reverts() public;
```

### test_notOwner_transferOwnershipOp_reverts

tests that the StateBridge contract's ownership can't be changed by a non-owner


```solidity
function test_notOwner_transferOwnershipOp_reverts(address nonOwner, address newOwner, bool isLocal)
    public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`nonOwner`|`address`||
|`newOwner`|`address`|The new owner of the StateBridge contract (foundry fuzz)|
|`isLocal`|`bool`||


### test_notOwner_SetRootHistoryExpiry_reverts

tests whether the StateBridge contract can set root history expiry on Optimism and Polygon


```solidity
function test_notOwner_SetRootHistoryExpiry_reverts(address nonOwner, uint256 _rootHistoryExpiry)
    public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`nonOwner`|`address`||
|`_rootHistoryExpiry`|`uint256`|The new root history expiry for OpWorldID and PolygonWorldID|


### test_notOwner_acceptOwnership_reverts

Tests that a nonPendingOwner can't accept ownership of StateBridge


```solidity
function test_notOwner_acceptOwnership_reverts(address newOwner, address randomAddress) public;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`newOwner`|`address`|the new owner of the contract|
|`randomAddress`|`address`||


### test_owner_renounceOwnership_reverts

Tests that ownership can't be renounced


```solidity
function test_owner_renounceOwnership_reverts() public;
```

### test_setGasLimitToZero_reverts

Tests that the StateBridge contract can't set the opGasLimit for sendRootOptimism to 0


```solidity
function test_setGasLimitToZero_reverts() public;
```

## Events
### OwnershipTransferStarted
EVENTS                           ///

Emitted when the ownership transfer of OpStateBridge is started (OZ Ownable2Step)


```solidity
event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);
```

### OwnershipTransferred
Emitted when the ownership transfer of OpStateBridge is accepted (OZ Ownable2Step)


```solidity
event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
```

### RootPropagated

```solidity
event RootPropagated(uint256 root);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`root`|`uint256`|The root sent to the OPWorldID contract on the OP Stack chain|

### OwnershipTransferredOp
Emitted when the the StateBridge gives ownership of the OPWorldID contract
to the WorldID Identity Manager contract away


```solidity
event OwnershipTransferredOp(address indexed previousOwner, address indexed newOwner, bool isLocal);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`previousOwner`|`address`|The previous owner of the OPWorldID contract|
|`newOwner`|`address`|The new owner of the OPWorldID contract|
|`isLocal`|`bool`|Whether the ownership transfer is local (Optimism/OP Stack chain EOA/contract) or an Ethereum EOA or contract|

### SetRootHistoryExpiry
Emitted when the the StateBridge sets the root history expiry for OpWorldID and PolygonWorldID


```solidity
event SetRootHistoryExpiry(uint256 rootHistoryExpiry);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`rootHistoryExpiry`|`uint256`|The new root history expiry|

### SetGasLimitPropagateRoot
Emitted when the the StateBridge sets the gas limit for sendRootOp


```solidity
event SetGasLimitPropagateRoot(uint32 _opGasLimit);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_opGasLimit`|`uint32`|The new opGasLimit for sendRootOp|

### SetGasLimitSetRootHistoryExpiry
Emitted when the the StateBridge sets the gas limit for SetRootHistoryExpiryt


```solidity
event SetGasLimitSetRootHistoryExpiry(uint32 _opGasLimit);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_opGasLimit`|`uint32`|The new opGasLimit for SetRootHistoryExpirytimism|

### SetGasLimitTransferOwnershipOp
Emitted when the the StateBridge sets the gas limit for transferOwnershipOp


```solidity
event SetGasLimitTransferOwnershipOp(uint32 _opGasLimit);
```

**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_opGasLimit`|`uint32`|The new opGasLimit for transferOwnershipOptimism|

## Errors
### invalidCrossDomainMessengerFork
emitted if there is no CrossDomainMessenger contract deployed on the fork


```solidity
error invalidCrossDomainMessengerFork();
```

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
Emitted when an attempt is made to set the owner to the zero address


```solidity
error AddressZero();
```

