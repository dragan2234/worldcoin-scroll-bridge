# BytesUtilsTest
[Git Source](https://github.com/SwineCoder101/world-id-state-bridge/blob/da63ea15118c125576858d5f20d9bfdd91cb337f/src/test/BytesUtils.t.sol)

**Inherits:**
PRBTest, StdCheats

**Author:**
Worldcoin

Tests the low-level assembly functions `grabSelector` and `stripSelector` in the BytesUtils library


## Functions
### testGrabSelectorSucceeds

SUCCEEDS                          ///

Tests that the `grabSelector` function returns the first 4 bytes of a payload.


```solidity
function testGrabSelectorSucceeds(string memory sig) public;
```

### testStripSelectorSucceeds

Tests that the `stripSelector` function returns the payload after the first 4 bytes.


```solidity
function testStripSelectorSucceeds(string memory sig) public;
```

### testDifferentSigsDontCollideSucceeds

tests that different function signatures create different selectors (a bit obvious)


```solidity
function testDifferentSigsDontCollideSucceeds(string memory sig, string memory notSig) public;
```

### testGrabSelectorPayloadTooShortReverts

REVERTS                           ///

Tests that the `grabSelector` function reverts when the payload is too short (<4 bytes)
to contain a selector.


```solidity
function testGrabSelectorPayloadTooShortReverts(bytes2 lessThanFourBytes, bytes4 fourOrMoreBytes)
    public;
```

### testStripSelectorPayloadTooShortReverts

Tests that the `stripSelector` function reverts when the payload is too short (<5 bytes)
to contain a payload after the selctor


```solidity
function testStripSelectorPayloadTooShortReverts(bytes4 fourBytesOrLess, bytes5 moreThanFourBytes)
    public;
```

## Errors
### PayloadTooShort
Emitted when the payload is too short to contain a selector (at least 4 bytes).


```solidity
error PayloadTooShort();
```

