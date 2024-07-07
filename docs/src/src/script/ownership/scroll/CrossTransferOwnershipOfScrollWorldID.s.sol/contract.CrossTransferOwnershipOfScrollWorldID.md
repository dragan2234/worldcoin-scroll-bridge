# CrossTransferOwnershipOfScrollWorldID
[Git Source](https://github.com/SwineCoder101/world-id-state-bridge/blob/da63ea15118c125576858d5f20d9bfdd91cb337f/src/script/ownership/scroll/CrossTransferOwnershipOfScrollWorldID.s.sol)

**Inherits:**
Script

**Author:**
Worldcoin


## State Variables
### isLocal
in ScrollCrossDomainOwnable.sol, isLocal is used to set ownership to a new address with a toggle
for local or cross domain (using the ScrollMessenger to pass messages)


```solidity
bool public isLocal;
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


### newOwner

```solidity
address public newOwner = vm.envAddress("NEW_OWNER");
```


## Functions
### constructor


```solidity
constructor();
```

### run


```solidity
function run() public;
```

