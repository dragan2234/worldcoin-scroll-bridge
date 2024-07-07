# SemaphoreVerifier
[Git Source](https://github.com/SwineCoder101/world-id-state-bridge/blob/da63ea15118c125576858d5f20d9bfdd91cb337f/src/SemaphoreVerifier.sol)

**Inherits:**
[ISemaphoreVerifier](/src/interfaces/ISemaphoreVerifier.sol/interface.ISemaphoreVerifier.md)

**Author:**
Remco Bloemen

Supports verifying Groth16 proofs. Proofs can be in uncompressed
(256 bytes) and compressed (128 bytes) format. A view function is provided
to compress proofs.

See <https://2π.com/23/bn254-compression> for further explanation.


## State Variables
### PRECOMPILE_MODEXP

```solidity
uint256 constant PRECOMPILE_MODEXP = 0x05;
```


### PRECOMPILE_ADD

```solidity
uint256 constant PRECOMPILE_ADD = 0x06;
```


### PRECOMPILE_MUL

```solidity
uint256 constant PRECOMPILE_MUL = 0x07;
```


### PRECOMPILE_VERIFY

```solidity
uint256 constant PRECOMPILE_VERIFY = 0x08;
```


### P

```solidity
uint256 constant P = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47;
```


### R

```solidity
uint256 constant R = 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001;
```


### FRACTION_1_2_FP

```solidity
uint256 constant FRACTION_1_2_FP =
    0x183227397098d014dc2822db40c0ac2ecbc0b548b438e5469e10460b6c3e7ea4;
```


### FRACTION_27_82_FP

```solidity
uint256 constant FRACTION_27_82_FP =
    0x2b149d40ceb8aaae81be18991be06ac3b5b4c5e559dbefa33267e6dc24a138e5;
```


### FRACTION_3_82_FP

```solidity
uint256 constant FRACTION_3_82_FP =
    0x2fcd3ac2a640a154eb23960892a85a68f031ca0c8344b23a577dcf1052b9e775;
```


### EXP_INVERSE_FP

```solidity
uint256 constant EXP_INVERSE_FP = 0x30644E72E131A029B85045B68181585D97816A916871CA8D3C208C16D87CFD45;
```


### EXP_SQRT_FP

```solidity
uint256 constant EXP_SQRT_FP = 0xC19139CB84C680A6E14116DA060561765E05AA45A1C72A34F082305B61F3F52;
```


### ALPHA_X

```solidity
uint256 constant ALPHA_X =
    20491192805390485299153009773594534940189261866228447918068658471970481763042;
```


### ALPHA_Y

```solidity
uint256 constant ALPHA_Y =
    9383485363053290200918347156157836566562967994039712273449902621266178545958;
```


### BETA_NEG_X_0

```solidity
uint256 constant BETA_NEG_X_0 =
    6375614351688725206403948262868962793625744043794305715222011528459656738731;
```


### BETA_NEG_X_1

```solidity
uint256 constant BETA_NEG_X_1 =
    4252822878758300859123897981450591353533073413197771768651442665752259397132;
```


### BETA_NEG_Y_0

```solidity
uint256 constant BETA_NEG_Y_0 =
    11383000245469012944693504663162918391286475477077232690815866754273895001727;
```


### BETA_NEG_Y_1

```solidity
uint256 constant BETA_NEG_Y_1 =
    41207766310529818958173054109690360505148424997958324311878202295167071904;
```


### GAMMA_NEG_X_0

```solidity
uint256 constant GAMMA_NEG_X_0 =
    10857046999023057135944570762232829481370756359578518086990519993285655852781;
```


### GAMMA_NEG_X_1

```solidity
uint256 constant GAMMA_NEG_X_1 =
    11559732032986387107991004021392285783925812861821192530917403151452391805634;
```


### GAMMA_NEG_Y_0

```solidity
uint256 constant GAMMA_NEG_Y_0 =
    13392588948715843804641432497768002650278120570034223513918757245338268106653;
```


### GAMMA_NEG_Y_1

```solidity
uint256 constant GAMMA_NEG_Y_1 =
    17805874995975841540914202342111839520379459829704422454583296818431106115052;
```


### DELTA_NEG_X_0

```solidity
uint256 constant DELTA_NEG_X_0 =
    15028154694713144242204861571552635520290993855826554325002991692907421516918;
```


### DELTA_NEG_X_1

```solidity
uint256 constant DELTA_NEG_X_1 =
    10202326166286888893675634318107715186834588694714750762952081034135561546271;
```


### DELTA_NEG_Y_0

```solidity
uint256 constant DELTA_NEG_Y_0 =
    9121952986466441409625823112409402110610350380222160673756836983949377617226;
```


### DELTA_NEG_Y_1

```solidity
uint256 constant DELTA_NEG_Y_1 =
    3402203030459169245973828223647408421795734658790470725360311404592929738724;
```


### CONSTANT_X

```solidity
uint256 constant CONSTANT_X =
    1452272927738590248356371174422184656932731110936062990115610832462181634644;
```


### CONSTANT_Y

```solidity
uint256 constant CONSTANT_Y =
    3608050114233210789542189629343107890943266759827387991788718454179833288695;
```


### PUB_0_X

```solidity
uint256 constant PUB_0_X =
    14798240452388909327945424685903532333765637883272751382037716636327236955001;
```


### PUB_0_Y

```solidity
uint256 constant PUB_0_Y =
    10773894897711848209682368488916121016695006898681985691467605219098835500201;
```


### PUB_1_X

```solidity
uint256 constant PUB_1_X =
    17204267933132009093604099819536245144503489322639121825381131096467570698650;
```


### PUB_1_Y

```solidity
uint256 constant PUB_1_Y =
    7704298975420304156332734115679983371345754866278811368869074990486717531131;
```


### PUB_2_X

```solidity
uint256 constant PUB_2_X =
    8060465662017324080560848316478407038163145149983639907596180500095598669247;
```


### PUB_2_Y

```solidity
uint256 constant PUB_2_Y =
    20475082166427284188002500222093571716651248980245637602667562336751029856573;
```


### PUB_3_X

```solidity
uint256 constant PUB_3_X =
    7457566682692308112726332096733260585025339741083447785327706250123165087868;
```


### PUB_3_Y

```solidity
uint256 constant PUB_3_Y =
    11904519443874922292602150685069370036383697877657723976244907400392778002614;
```


## Functions
### negate

Negation in Fp.

Returns a number x such that a + x = 0 in Fp.

The input does not need to be reduced.


```solidity
function negate(uint256 a) internal pure returns (uint256 x);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint256`|the base|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`x`|`uint256`|the result|


### exp

Exponentiation in Fp.

Returns a number x such that a ^ e = x in Fp.

The input does not need to be reduced.


```solidity
function exp(uint256 a, uint256 e) internal view returns (uint256 x);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint256`|the base|
|`e`|`uint256`|the exponent|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`x`|`uint256`|the result|


### invert_Fp

Invertsion in Fp.

Returns a number x such that a * x = 1 in Fp.

The input does not need to be reduced.

Reverts with ProofInvalid() if the inverse does not exist


```solidity
function invert_Fp(uint256 a) internal view returns (uint256 x);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint256`|the input|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`x`|`uint256`|the solution|


### sqrt_Fp

Square root in Fp.

Returns a number x such that x * x = a in Fp.

Will revert with InvalidProof() if the input is not a square
or not reduced.


```solidity
function sqrt_Fp(uint256 a) internal view returns (uint256 x);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint256`|the square|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`x`|`uint256`|the solution|


### isSquare_Fp

Square test in Fp.

Returns wheter a number x exists such that x * x = a in Fp.

Will revert with InvalidProof() if the input is not a square
or not reduced.


```solidity
function isSquare_Fp(uint256 a) internal view returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint256`|the square|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|x the solution|


### sqrt_Fp2

Square root in Fp2.

Fp2 is the complex extension Fp[i]/(i^2 + 1). The input is
a0 + a1 ⋅ i and the result is x0 + x1 ⋅ i.

Will revert with InvalidProof() if
* the input is not a square,
* the hint is incorrect, or
* the input coefficents are not reduced.


```solidity
function sqrt_Fp2(uint256 a0, uint256 a1, bool hint)
    internal
    view
    returns (uint256 x0, uint256 x1);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|The real part of the input.|
|`a1`|`uint256`|The imaginary part of the input.|
|`hint`|`bool`|A hint which of two possible signs to pick in the equation.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`x0`|`uint256`|The real part of the square root.|
|`x1`|`uint256`|The imaginary part of the square root.|


### compress_g1

Compress a G1 point.

Reverts with InvalidProof if the coordinates are not reduced
or if the point is not on the curve.

The point at infinity is encoded as (0,0) and compressed to 0.


```solidity
function compress_g1(uint256 x, uint256 y) internal view returns (uint256 c);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`x`|`uint256`|The X coordinate in Fp.|
|`y`|`uint256`|The Y coordinate in Fp.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`c`|`uint256`|The compresed point (x with one signal bit).|


### decompress_g1

Decompress a G1 point.

Reverts with InvalidProof if the input does not represent a valid point.

The point at infinity is encoded as (0,0) and compressed to 0.


```solidity
function decompress_g1(uint256 c) internal view returns (uint256 x, uint256 y);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`c`|`uint256`|The compresed point (x with one signal bit).|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`x`|`uint256`|The X coordinate in Fp.|
|`y`|`uint256`|The Y coordinate in Fp.|


### compress_g2

Compress a G2 point.

Reverts with InvalidProof if the coefficients are not reduced
or if the point is not on the curve.

The G2 curve is defined over the complex extension Fp[i]/(i^2 + 1)
with coordinates (x0 + x1 ⋅ i, y0 + y1 ⋅ i).

The point at infinity is encoded as (0,0,0,0) and compressed to (0,0).


```solidity
function compress_g2(uint256 x0, uint256 x1, uint256 y0, uint256 y1)
    internal
    view
    returns (uint256 c0, uint256 c1);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`x0`|`uint256`|The real part of the X coordinate.|
|`x1`|`uint256`|The imaginary poart of the X coordinate.|
|`y0`|`uint256`|The real part of the Y coordinate.|
|`y1`|`uint256`|The imaginary part of the Y coordinate.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`c0`|`uint256`|The first half of the compresed point (x0 with two signal bits).|
|`c1`|`uint256`|The second half of the compressed point (x1 unmodified).|


### decompress_g2

Decompress a G2 point.

Reverts with InvalidProof if the input does not represent a valid point.

The G2 curve is defined over the complex extension Fp[i]/(i^2 + 1)
with coordinates (x0 + x1 ⋅ i, y0 + y1 ⋅ i).

The point at infinity is encoded as (0,0,0,0) and compressed to (0,0).


```solidity
function decompress_g2(uint256 c0, uint256 c1)
    internal
    view
    returns (uint256 x0, uint256 x1, uint256 y0, uint256 y1);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`c0`|`uint256`|The first half of the compresed point (x0 with two signal bits).|
|`c1`|`uint256`|The second half of the compressed point (x1 unmodified).|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`x0`|`uint256`|The real part of the X coordinate.|
|`x1`|`uint256`|The imaginary poart of the X coordinate.|
|`y0`|`uint256`|The real part of the Y coordinate.|
|`y1`|`uint256`|The imaginary part of the Y coordinate.|


### publicInputMSM

Compute the public input linear combination.

Reverts with PublicInputNotInField if the input is not in the field.

Computes the multi-scalar-multiplication of the public input
elements and the verification key including the constant term.


```solidity
function publicInputMSM(uint256[4] calldata input) internal view returns (uint256 x, uint256 y);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`input`|`uint256[4]`|The public inputs. These are elements of the scalar field Fr.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`x`|`uint256`|The X coordinate of the resulting G1 point.|
|`y`|`uint256`|The Y coordinate of the resulting G1 point.|


### compressProof

Compress a proof.

Will revert with InvalidProof if the curve points are invalid,
but does not verify the proof itself.


```solidity
function compressProof(uint256[8] calldata proof)
    public
    view
    returns (uint256[4] memory compressed);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`proof`|`uint256[8]`|The uncompressed Groth16 proof. Elements are in the same order as for verifyProof. I.e. Groth16 points (A, B, C) encoded as in EIP-197.|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`compressed`|`uint256[4]`|The compressed proof. Elements are in the same order as for verifyCompressedProof. I.e. points (A, B, C) in compressed format.|


### verifyCompressedProof

Verify a Groth16 proof with compressed points.

Reverts with InvalidProof if the proof is invalid or
with PublicInputNotInField the public input is not reduced.

There is no return value. If the function does not revert, the
proof was succesfully verified.


```solidity
function verifyCompressedProof(uint256[4] calldata compressedProof, uint256[4] calldata input)
    public
    view;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`compressedProof`|`uint256[4]`|the points (A, B, C) in compressed format matching the output of compressProof.|
|`input`|`uint256[4]`|the public input field elements in the scalar field Fr. Elements must be reduced.|


### verifyProof

Verify an uncompressed Groth16 proof.

Reverts with InvalidProof if the proof is invalid or
with PublicInputNotInField the public input is not reduced.

There is no return value. If the function does not revert, the
proof was succesfully verified.


```solidity
function verifyProof(uint256[8] calldata proof, uint256[4] calldata input) public view;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`proof`|`uint256[8]`|the points (A, B, C) in EIP-197 format matching the output of compressProof.|
|`input`|`uint256[4]`|the public input field elements in the scalar field Fr. Elements must be reduced.|


## Errors
### PublicInputNotInField
Some of the provided public input values are larger than the field modulus.

*Public input elements are not automatically reduced, as this is can be
a dangerous source of bugs.*


```solidity
error PublicInputNotInField();
```

### ProofInvalid
The proof is invalid.

*This can mean that provided Groth16 proof points are not on their
curves, that pairing equation fails, or that the proof is not for the
provided public input.*


```solidity
error ProofInvalid();
```

