# worldcoin-scroll-bridge

Docs copied from: https://github.com/worldcoin/world-id-state-bridge/pull/112



### Build your own state bridge

#### Intro

The point of the state bridge contracts in `world-id-state-bridge` is to have two contracts, one deployed on Ethereum
mainnet and the other one on a target L2. The mainnet contract (e.g. `OpStateBridge`) has a public function which will
fetch the latest root of the World ID merkle tree using the
[`WorldIDIdentityManagerImplV1`](https://github.com/worldcoin/world-id-contracts/blob/main/src/WorldIDIdentityManagerImplV1.sol)
method named
[`latestRoot()`](https://github.com/worldcoin/world-id-contracts/blob/42c26ecbd82fba56983addee6485d5b617960a2a/src/WorldIDIdentityManagerImplV1.sol#L433-L438)
and then will use the native L1<>L2 messaging layer to send a message to the target L2 contract (e.g. `OpWorldID`). The
messaging layer of the L2 will forward the message to the target contract by calling the corresponding method on the L2
contract with the specified payload from the L1.

> [!NOTE] The current implementation of WorldID will only work for EVM-compatible networks as mentioned in the
> [Supported networks](#supported-networks) and [Future integrations](#future-integrations) sections. If you are an
> EVM-compatible rollup you also need to support the pairing cryptography and keccak256 precompiles.
The root of the World ID Identity Manager tree is the only public state that you need to send to the L2 in order to
verify Semaphore proofs (proofs of inclusion in the World ID merkle tree). As long as you have the root and a World ID
implementation on your network, you can deploy World ID on it.

#### Requirements

- service to sync the World ID merkle tree (currently only done by
  [`signup-sequencer`](https://github.com/worldcoin/signup-sequencer))
- EVM support on the L2 (pairing cryptography and keccak256 precompile support needed)
  - or a custom implementation of World ID for your execution environment (see
    [Future integrations](#future-integrations))
- native L1<>L2 data messaging layer (e.g. Optimism cross domain messenger, Arbitrum, etc)
- relayer service that periodically calls `propagateRoot()` as a cron job (e.g.
  [`state-bridge-relay`](https://github.com/worldcoin/state-bridge-relay))
- deployment scripts
- audits (World ID contracts, both `world-id-contracts` and `world-id-state-bridge` are audited by Nethermind
  ([1](https://github.com/NethermindEth/PublicAuditReports/blob/main/NM0131-FINAL_WORLDCOIN_STATE_BRIDGE_CONTRACTS_UPGRADE.pdf),
  [2](https://github.com/NethermindEth/PublicAuditReports/blob/main/NM0122-FINAL_WORLDCOIN.pdf)))

#### Specification

If you want to build your own state bridge, you can use the `OpStateBridge` contract as a template. The contract has two
main methods, namely
[`propagateRoot()`](https://github.com/worldcoin/world-id-state-bridge/blob/main/src/OpStateBridge.sol#L126) (fetches
the latest root from the
[Orb/Phone World ID IdentityManager contract](https://docs.worldcoin.org/reference/address-book) and propagates it to
the target L2 contract using the native L1->L2 messaging layer) and
[`setRootHistoryExpiry()`](https://github.com/worldcoin/world-id-state-bridge/blob/main/src/OpStateBridge.sol#L170)
(sets how long you want a propagated root to be valid for inclusion proofs) which you will need to implement. Most
native bridges will have a messenger/relayer contract and a generic interface you can use to call a function on a target
contract on the L2 with your desired calldata (which is the message). Another requirement for this system to work is to
only allow the contract on L1 to be able to call this function on the L2, otherwise anyone would be able to insert
arbitrary merkle tree roots into the L2 contract. On the `OpWorldID` contract we used a contract named
[`CrossDomainOwnable3`](https://github.com/ethereum-optimism/optimism/blob/develop/packages/contracts-bedrock/src/L2/CrossDomainOwnable3.sol)
which implements this functionality (checks that L1 sender is a given sender).

> [!NOTE] If you want to support World ID on an OP-stack network it is very easy as we have already implemented it for
> Optimism, the only change you need to make is within the deploy scripts where you need to set the
> [crossDomainMessengerAddress](https://github.com/worldcoin/world-id-state-bridge/blob/main/src/script/deploy/op-stack/optimism/DeployOptimismStateBridgeGoerli.s.sol#L32)
> to the your own network's cross domain messenger address on Ethereum L1 (whether mainnet or testnet).

