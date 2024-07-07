# SetGasLimitScroll
[Git Source](https://github.com/SwineCoder101/world-id-state-bridge/blob/da63ea15118c125576858d5f20d9bfdd91cb337f/src/script/ownership/scroll/SetGasLimitScroll.s.sol)

**Inherits:**
Script

**Author:**
Worldcoin


## State Variables
### scrollStateBridge

```solidity
ScrollStateBridge public scrollStateBridge;
```


### privateKey
CONFIG                           ///


```solidity
uint256 public privateKey = vm.envUint("PRIVATE_KEY");
```


### scrollStateBridgeAddress

```solidity
address public scrollStateBridgeAddress = vm.envAddress("SCROLL_STATE_BRIDGE");
```


### gasLimitPropagateRootScroll
SCROLL GAS LIMIT                      ///


```solidity
uint32 public gasLimitPropagateRootScroll = uint32(vm.envUint("GAS_LIMIT_SEND_ROOT_SCROLL"));
```


### gasLimitSetRootHistoryExpiryScroll

```solidity
uint32 public gasLimitSetRootHistoryExpiryScroll =
    uint32(vm.envUint("GAS_LIMIT_SET_ROOT_HISTORY_EXPIRY_SCROLL"));
```


### gasLimitTransferOwnershipScroll

```solidity
uint32 public gasLimitTransferOwnershipScroll =
    uint32(vm.envUint("GAS_LIMIT_TRANSFER_OWNERSHIP_SCROLL"));
```


## Functions
### setUp


```solidity
function setUp() public;
```

### run


```solidity
function run() public;
```

