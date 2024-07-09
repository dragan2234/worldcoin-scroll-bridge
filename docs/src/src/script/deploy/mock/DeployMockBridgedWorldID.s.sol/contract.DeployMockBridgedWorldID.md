# DeployMockBridgedWorldID
[Git Source](https://github.com/SwineCoder101/world-id-state-bridge/blob/da63ea15118c125576858d5f20d9bfdd91cb337f/src/script/deploy/mock/DeployMockBridgedWorldID.s.sol)

**Inherits:**
Script

**Author:**
Worldcoin

forge script to deploy MockBridgedWorldID.sol

*Can be executed by running `make local-mock`.*


## State Variables
### mockBridgedWorldID

```solidity
MockBridgedWorldID public mockBridgedWorldID;
```


### root
CONFIG                           ///


```solidity
string public root = vm.projectRoot();
```


### path

```solidity
string public path = string.concat(root, "/src/script/.deploy-config.json");
```


### json

```solidity
string public json = vm.readFile(path);
```


### privateKey

```solidity
uint256 public privateKey = abi.decode(vm.parseJson(json, ".privateKey"), (uint256));
```


### treeDepth

```solidity
uint8 public treeDepth = abi.decode(vm.parseJson(json, ".treeDepth"), (uint8));
```


## Functions
### run


```solidity
function run() external;
```

