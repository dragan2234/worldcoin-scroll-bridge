# LocalTransferOwnershipOfBaseWorldID
[Git Source](https://github.com/SwineCoder101/world-id-state-bridge/blob/da63ea15118c125576858d5f20d9bfdd91cb337f/src/script/ownership/scroll/LocalTransferOwnershipOfScrollWorldID.s.sol)

**Inherits:**
Script

**Author:**
Worldcoin

forge script for transferring ownership of OpWorldID to a local (Base / Base Goerli)
or cross-chain (Ethereum / Ethereum goerli) EOA or contract

*Can be executed by running `make mock`, `make local-mock`, `make deploy` or `make deploy-testnet`.*


## State Variables
### privateKey

```solidity
uint256 public privateKey;
```


### scrollWorldIDAddress

```solidity
address public scrollWorldIDAddress;
```


### newOwner

```solidity
address public newOwner;
```


### isLocal
in CrossDomainOwnable3.sol, isLocal is used to set ownership to a new address with a toggle
for local or cross domain (using the CrossDomainMessenger to pass messages)


```solidity
bool public isLocal;
```


### opGasLimit

```solidity
uint32 public opGasLimit;
```


## Functions
### setUp


```solidity
function setUp() public;
```

### constructor

CONFIG                           ///


```solidity
constructor();
```

### run


```solidity
function run() public;
```

