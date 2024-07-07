# DeployMockStateBridge
[Git Source](https://github.com/SwineCoder101/world-id-state-bridge/blob/da63ea15118c125576858d5f20d9bfdd91cb337f/src/script/deploy/mock/DeployMockStateBridge.s.sol)

**Inherits:**
Script

**Author:**
Worldcoin

forge script to deploy MockStateBridge.sol

*Can be executed by running `make mock` or `make local-mock`.*


## State Variables
### mockStateBridge

```solidity
MockStateBridge public mockStateBridge;
```


### mockWorldID

```solidity
MockWorldIDIdentityManager public mockWorldID;
```


### mockBridgedWorldID

```solidity
MockBridgedWorldID public mockBridgedWorldID;
```


### owner

```solidity
address owner;
```


### treeDepth

```solidity
uint8 treeDepth;
```


### initialRoot

```solidity
uint256 initialRoot;
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


## Functions
### setUp


```solidity
function setUp() public;
```

### run


```solidity
function run() public;
```

