# PropagateMockRoot
[Git Source](https://github.com/SwineCoder101/world-id-state-bridge/blob/da63ea15118c125576858d5f20d9bfdd91cb337f/src/script/test/PropagateMockRoot.s.sol)

**Inherits:**
Script

**Author:**
Worldcoin

*Can be executed by running `make local-mock`.*


## State Variables
### bridge

```solidity
MockStateBridge public bridge;
```


### mockStateBridgeAddress

```solidity
address public mockStateBridgeAddress;
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

