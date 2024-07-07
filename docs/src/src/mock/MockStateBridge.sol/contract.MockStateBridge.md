# MockStateBridge
[Git Source](https://github.com/SwineCoder101/world-id-state-bridge/blob/da63ea15118c125576858d5f20d9bfdd91cb337f/src/mock/MockStateBridge.sol)

**Inherits:**
Ownable

**Author:**
Worldcoin

Mock of the StateBridge to test functionality on a local chain


## State Variables
### worldID
MockWorldIDIdentityManager contract which will hold a mock root


```solidity
IWorldIDIdentityManager public worldID;
```


### mockBridgedWorldID
MockBridgedWorldID contract which will receive the root


```solidity
MockBridgedWorldID public mockBridgedWorldID;
```


## Functions
### constructor

constructor


```solidity
constructor(address _mockWorldID, address _mockBridgedWorldID);
```

### propagateRoot

Sends the latest WorldID Identity Manager root to the Bridged WorldID contract.

*Calls this method on the L1 Proxy contract to relay roots to WorldID supported chains.*


```solidity
function propagateRoot() public;
```

### _sendRootToMockBridgedWorldID

*Calls this method on the L1 Proxy contract to relay roots to WorldID supported chains.*


```solidity
function _sendRootToMockBridgedWorldID(uint256 root) internal;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`root`|`uint256`|The latest WorldID Identity Manager root.|


## Errors
### InvalidRoot
Emmited when the root is not a valid root in the canonical WorldID Identity Manager contract


```solidity
error InvalidRoot();
```

