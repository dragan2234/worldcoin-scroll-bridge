# DeployScrollStateBridgeGoerli
[Git Source](https://github.com/SwineCoder101/world-id-state-bridge/blob/da63ea15118c125576858d5f20d9bfdd91cb337f/src/script/deploy/scroll/DeployScrollStateBridgeMainnet.s.sol)

**Inherits:**
Script

**Author:**
Worldcoin

forge script to deploy StateBridge.sol on Scroll

*Demo deployments*

*Can be executed by running `make mock`, `make local-mock`, `make deploy` or `make deploy-testnet`.*


## State Variables
### bridge

```solidity
ScrollStateBridge public bridge;
```


### scrollL1MessengerAddress

```solidity
address public scrollL1MessengerAddress;
```


### privateKey
CONFIG                           ///


```solidity
uint256 public privateKey = vm.envUint("PRIVATE_KEY");
```


### worldIDIdentityManagerAddress

```solidity
address public worldIDIdentityManagerAddress = vm.envAddress("WORLD_ID_IDENTITY_MANAGER");
```


### scrollWorldIDAddress

```solidity
address public scrollWorldIDAddress = vm.envAddress("SCROLL_WORLD_ID");
```


## Functions
### setUp


```solidity
function setUp() public;
```

### run

SCROLL                           ///


```solidity
function run() public;
```

