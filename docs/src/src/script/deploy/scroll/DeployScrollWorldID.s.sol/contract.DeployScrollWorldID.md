# DeployScrollWorldID
[Git Source](https://github.com/SwineCoder101/world-id-state-bridge/blob/da63ea15118c125576858d5f20d9bfdd91cb337f/src/script/deploy/scroll/DeployScrollWorldID.s.sol)

**Inherits:**
Script

**Author:**
Worldcoin

forge script to deploy ScrollWorldID.sol to Scroll


## State Variables
### scrollWorldID

```solidity
ScrollWorldID public scrollWorldID;
```


### root
CONFIG                           ///


```solidity
string public root = vm.projectRoot();
```


### privateKey

```solidity
uint256 public privateKey = vm.envUint("PRIVATE_KEY");
```


### treeDepth

```solidity
uint8 public treeDepth = uint8(30);
```


## Functions
### run


```solidity
function run() external;
```

