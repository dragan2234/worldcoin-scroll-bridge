# DeployMockWorldID
[Git Source](https://github.com/SwineCoder101/world-id-state-bridge/blob/da63ea15118c125576858d5f20d9bfdd91cb337f/src/script/deploy/mock/DeployMockWorldID.s.sol)

**Inherits:**
Script

**Author:**
Worldcoin

forge script to deploy MockWorldIDIdentityManager.sol

*Demo deployments*

*Can be executed by running `make mock` or `make local-mock`.*


## State Variables
### worldID

```solidity
MockWorldIDIdentityManager public worldID;
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


### sampleRoot

```solidity
uint256 public sampleRoot = abi.decode(vm.parseJson(json, ".sampleRoot"), (uint256));
```


## Functions
### run


```solidity
function run() external;
```

