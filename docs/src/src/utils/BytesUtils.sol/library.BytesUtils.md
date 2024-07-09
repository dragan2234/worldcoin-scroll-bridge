# BytesUtils
[Git Source](https://github.com/SwineCoder101/world-id-state-bridge/blob/da63ea15118c125576858d5f20d9bfdd91cb337f/src/utils/BytesUtils.sol)


## Functions
### grabSelector

grabSelector, takes a byte array _payload as input and returns the first 4 bytes
of the array as a bytes4 value _selector. The function uses EVM assembly language
to load the 4-byte selector from the _payload array and then shift it left by 224 bits
(0xE0 in hexadecimal) to get the correct value.

*This function is currently unused*


```solidity
function grabSelector(bytes memory _payload) internal pure returns (bytes4 _selector);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_payload`|`bytes`|The byte array from which to extract the selector|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`_selector`|`bytes4`|The first 4 bytes of the _payload array (the function selector from encodeWithSignature)|


### stripSelector

stripSelector, takes a byte array _payload as input and returns a new byte array
_payloadData that contains all the data in _payload except for the first 4 bytes (the selector).
The function first allocates a new block of memory to store the new byte array, then copies the
length of the original _payload array (minus 4 bytes) into the new array, and then copies the
remaining data from the original _payload array into the new array, starting from the fifth byte.
The function then updates the free memory pointer to account for the new memory allocation.

*uses mload to load the first 32 bytes of _payload
(starting at memory address _payload + 0x20) into memory,
then shr to shift the loaded value right by 224 bits
(0xE0 in hexadecimal). Therefore only the last 4 bytes (32 bits remain),
and finally we pad the value to the left by using shl to shift
the by 224 bits to the left to get the correct value for _selector.*

*This function is currently unused*


```solidity
function stripSelector(bytes memory _payload) internal pure returns (bytes memory _payloadData);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_payload`|`bytes`|The byte array from which to extract the payload data|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`_payloadData`|`bytes`|The payload data from the _payload array (payload minus selector which is 4 bytes long)|


### substring

*These lines copy the length of the original _payload array
(minus 4 bytes for the selector) into the first 32 bytes of the new
_payloadData array. Specifically, it uses mload to load the value stored
at memory address _payload, which is the length of the _payload array,
and then sub to subtract 4 from this value to get the correct length for
_payloadData. Finally, it uses mstore to store this value at memory address _payloadData.*

*Copies a substring into a new byte string. Used in PolygonWorldID.sol*


```solidity
function substring(bytes memory self, uint256 offset, uint256 len)
    internal
    pure
    returns (bytes memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`self`|`bytes`|The byte string to copy from.|
|`offset`|`uint256`|The offset to start copying at.|
|`len`|`uint256`|The number of bytes to copy.|


### memcpy

*Copies a memory block to another memory block.*


```solidity
function memcpy(uint256 dest, uint256 src, uint256 len) private pure;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`dest`|`uint256`|The destination memory pointer.|
|`src`|`uint256`|The source memory pointer.|
|`len`|`uint256`|The length of the memory block to copy.|


## Errors
### PayloadTooShort
Emitted when the payload is too short to contain a selector (at least 4 bytes).


```solidity
error PayloadTooShort();
```

