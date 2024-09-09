// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {ScrollStateBridge} from "src/ScrollStateBridge.sol";   
import {MockWorldIDIdentityManager} from "src/mock/MockWorldIDIdentityManager.sol";
import {MockBridgedWorldID} from "src/mock/MockBridgedWorldID.sol";

import {PRBTest} from "@prb/test/PRBTest.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

/// @title State Bridge Test
/// @author Worldcoin
/// @notice A test contract for StateBridge.sol
contract ScrollStateBridgeTest is PRBTest, StdCheats {
    ///////////////////////////////////////////////////////////////////
    ///                        STORAGE CONFIG                       ///
    ///////////////////////////////////////////////////////////////////
    uint256 public mainnetFork;
    string private SEPOLIA_RPC_URL = vm.envString("MAINNET_RPC_URL");

    /// @notice emitted if there is no CrossDomainMessenger contract deployed on the fork
    error invalidCrossDomainMessengerFork();

    ScrollStateBridge public scStateBridge;
    MockWorldIDIdentityManager public mockWorldID;

    uint32 public scGasLimit;

    address public mockWorldIDAddress;

    address public owner;

    /// @notice The address of the OpWorldID contract on any OP Stack chain
    address public opWorldIDAddress;

    /// @notice address for OP Stack chain Ethereum mainnet L1CrossDomainMessenger contract
    address public opCrossDomainMessengerAddress;

    uint256 public sampleRoot;

    ///////////////////////////////////////////////////////////////////
    ///                            EVENTS                           ///
    ///////////////////////////////////////////////////////////////////

    /// @notice Emitted when the ownership transfer of OpStateBridge is started (OZ Ownable2Step)
    event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);

    /// @notice Emitted when the ownership transfer of OpStateBridge is accepted (OZ Ownable2Step)
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // @notice Emitted when the the StateBridge sends a root to the OPWorldID contract
    /// @param root The root sent to the OPWorldID contract on the OP Stack chain
    event RootPropagated(uint256 root);

    /// @notice Emitted when the the StateBridge gives ownership of the OPWorldID contract
    /// to the WorldID Identity Manager contract away
    /// @param previousOwner The previous owner of the OPWorldID contract
    /// @param newOwner The new owner of the OPWorldID contract
    /// @param isLocal Whether the ownership transfer is local (Optimism/OP Stack chain EOA/contract) or an Ethereum EOA or contract
    event OwnershipTransferredScroll(
        address indexed previousOwner, address indexed newOwner, bool isLocal
    );

    /// @notice Emitted when the the StateBridge sets the root history expiry for OpWorldID and PolygonWorldID
    /// @param rootHistoryExpiry The new root history expiry
    event SetRootHistoryExpiry(uint256 rootHistoryExpiry);

    /// @notice Emitted when the the StateBridge sets the gas limit for sendRootOp
    /// @param _opGasLimit The new opGasLimit for sendRootOp
    event SetGasLimitPropagateRoot(uint32 _opGasLimit);

    /// @notice Emitted when the the StateBridge sets the gas limit for SetRootHistoryExpiryt
    /// @param _opGasLimit The new opGasLimit for SetRootHistoryExpirytimism
    event SetGasLimitSetRootHistoryExpiry(uint32 _opGasLimit);

    /// @notice Emitted when the the StateBridge sets the gas limit for transferOwnershipOp
    /// @param _opGasLimit The new opGasLimit for transferOwnershipOptimism
    event SetGasLimitTransferOwnershipScroll(uint32 _opGasLimit);

    ///////////////////////////////////////////////////////////////////
    ///                            ERRORS                           ///
    ///////////////////////////////////////////////////////////////////

    /// @notice Emitted when an attempt is made to renounce ownership.
    error CannotRenounceOwnership();

    /// @notice Emitted when an attempt is made to set the gas limit to zero
    error GasLimitZero();

    /// @notice Emitted when an attempt is made to set the owner to the zero address
    error AddressZero();

    function setUp() public {
        /// @notice Create a fork of the Ethereum mainnet
        mainnetFork = vm.createSelectFork(SEPOLIA_RPC_URL);

        scrollCrossDomainMessengerAddress = address(0x6774Bcbd5ceCeF1336b5300fb5186a12DDD8b367);
    

        // inserting mock root
        sampleRoot = uint256(0x111);
        mockWorldID = new MockWorldIDIdentityManager(sampleRoot);
        mockWorldIDAddress = address(mockWorldID);

        opWorldIDAddress = address(0x1);

        scStateBridge =
            new ScrollStateBridge(mockWorldIDAddress, opWorldIDAddress, opCrossDomainMessengerAddress);

        owner = scStateBridge.owner();
        deal(owner, 100 ether);
    }

    ///////////////////////////////////////////////////////////////////
    ///                           SUCCEEDS                          ///
    ///////////////////////////////////////////////////////////////////

    /// @notice select a specific fork
    function test_canSelectFork_succeeds() public {
        // select the fork
        vm.selectFork(mainnetFork);
        assertEq(vm.activeFork(), mainnetFork);
    }

    function test_propagateRoot_suceeds() public {
        vm.expectEmit(true, true, true, true);
        emit RootPropagated(sampleRoot);

        scStateBridge.propagateRoot{value: 2 ether}(address(this), 0);

        // Bridging is not emulated
    }

    /// @notice Tests that the owner of the StateBridge contract can transfer ownership
    /// using Ownable2Step transferOwnership
    /// @param newOwner the new owner of the contract
    function test_owner_transferOwnership_succeeds(address newOwner) public {
        vm.assume(newOwner != address(0));

        vm.expectEmit(true, true, true, true);

        // OpenZeppelin Ownable2Step transferOwnershipStarted event
        emit OwnershipTransferStarted(owner, newOwner);

        vm.prank(owner);
        scStateBridge.transferOwnership(newOwner);

        vm.expectEmit(true, true, true, true);

        // OpenZeppelin Ownable2Step transferOwnership event
        emit OwnershipTransferred(owner, newOwner);

        vm.prank(newOwner);
        scStateBridge.acceptOwnership();

        assertEq(scStateBridge.owner(), newOwner);
    }

    /// @notice tests whether the StateBridge contract can transfer ownership of the OPWorldID contract
    /// @param newOwner The new owner of the OPWorldID contract (foundry fuzz)
    /// @param isLocal Whether the ownership transfer is local (Optimism EOA/contract) or an Ethereum EOA or contract
    function test_owner_transferOwnershipOp_succeeds(address newOwner, bool isLocal) public {
        vm.assume(newOwner != address(0));
        // vm.expectEmit(true, true, true, true);

        // CrossDomainOwnable3.sol transferOwnership event
        emit OwnershipTransferredScroll(owner, newOwner, isLocal);

        vm.prank(owner);
        scStateBridge.transferOwnershipScroll{value: 2 ether}(newOwner, isLocal,0, owner);
    }

    /// @notice tests whether the StateBridge contract can set root history expiry on Optimism and Polygon
    /// @param _rootHistoryExpiry The new root history expiry for OpWorldID and PolygonWorldID
    function test_owner_setRootHistoryExpiry_succeeds(uint256 _rootHistoryExpiry) public {
        vm.expectEmit(true, true, true, true);
        emit SetRootHistoryExpiry(_rootHistoryExpiry);

        vm.prank(owner);
        scStateBridge.setRootHistoryExpiry{value: 2 ether}(_rootHistoryExpiry,0, owner);
    }

    /// @notice tests whether the StateBridge contract can set the opGasLimit for sendRootOptimism
    /// @param _opGasLimit The new opGasLimit for sendRootOptimism
    function test_owner_setGasLimitPropagateRoot_succeeds(uint32 _opGasLimit) public {
        vm.assume(_opGasLimit != 0);

        vm.expectEmit(true, true, true, true);

        emit SetGasLimitPropagateRoot(_opGasLimit);

        vm.prank(owner);
        scStateBridge.setGasLimitPropagateRoot(_opGasLimit);
    }

    /// @notice tests whether the StateBridge contract can set the opGasLimit for SetRootHistoryExpirytimism
    /// @param _opGasLimit The new opGasLimit for SetRootHistoryExpirytimism
    function test_owner_setGasLimitSetRootHistoryExpiry_succeeds(uint32 _opGasLimit) public {
        vm.assume(_opGasLimit != 0);

        vm.expectEmit(true, true, true, true);

        emit SetGasLimitSetRootHistoryExpiry(_opGasLimit);

        vm.prank(owner);
        scStateBridge.setGasLimitSetRootHistoryExpiry(_opGasLimit);
    }

    /// @notice tests whether the StateBridge contract can set the opGasLimit for transferOwnershipOptimism
    /// @param _opGasLimit The new opGasLimit for transferOwnershipOptimism
    function test_owner_setGasLimitTransferOwnershipSc_succeeds(uint32 _opGasLimit) public {
        vm.assume(_opGasLimit != 0);

        vm.expectEmit(true, true, true, true);

        emit SetGasLimitTransferOwnershipScroll(_opGasLimit);

        vm.prank(owner);
        scStateBridge.setGasLimitTransferOwnershipScroll(_opGasLimit);
    }

    ///////////////////////////////////////////////////////////////////
    ///                           REVERTS                           ///
    ///////////////////////////////////////////////////////////////////

    /// @notice Tests that the StateBridge constructor params can't be set to the zero address
    function test_cannotInitializeConstructorWithZeroAddresses_reverts() public {
        vm.expectRevert(AddressZero.selector);
        scStateBridge =
            new ScrollStateBridge(address(0), opWorldIDAddress, opCrossDomainMessengerAddress);

        vm.expectRevert(AddressZero.selector);
        scStateBridge =
            new ScrollStateBridge(mockWorldIDAddress, address(0), opCrossDomainMessengerAddress);

        vm.expectRevert(AddressZero.selector);
        scStateBridge = new ScrollStateBridge(mockWorldIDAddress, opWorldIDAddress, address(0));
    }

    /// @notice tests that the StateBridge contract's ownership can't be changed by a non-owner
    /// @param newOwner The new owner of the StateBridge contract (foundry fuzz)
    /// @param nonOwner An address that is not the owner of the StateBridge contract
    function test_notOwner_transferOwnership_reverts(address nonOwner, address newOwner) public {
        vm.assume(nonOwner != owner && nonOwner != address(0) && newOwner != address(0));

        vm.expectRevert("Ownable: caller is not the owner");

        vm.prank(nonOwner);
        scStateBridge.transferOwnership(newOwner);
    }

    /// @notice tests that the StateBridge contract's ownership can't be set to be the zero address
    function test_owner_transferOwnershipOp_toZeroAddress_reverts() public {
        vm.expectRevert(AddressZero.selector);

        vm.prank(owner);
        scStateBridge.transferOwnershipScroll{value: 1 ether}(address(0), true, 0, owner);
    }

    /// @notice tests that the StateBridge contract's ownership can't be changed by a non-owner
    /// @param newOwner The new owner of the StateBridge contract (foundry fuzz)
    function test_notOwner_transferOwnershipOp_reverts(
        address nonOwner,
        address newOwner,
        bool isLocal
    ) public {
        vm.assume(nonOwner != owner && newOwner != address(0));

        vm.expectRevert("Ownable: caller is not the owner");

        vm.prank(nonOwner);
        scStateBridge.transferOwnershipScroll(newOwner, isLocal,0, nonOwner);
    }

    /// @notice tests whether the StateBridge contract can set root history expiry on Optimism and Polygon
    /// @param _rootHistoryExpiry The new root history expiry for OpWorldID and PolygonWorldID
    function test_notOwner_SetRootHistoryExpiry_reverts(
        address nonOwner,
        uint256 _rootHistoryExpiry
    ) public {
        vm.assume(nonOwner != owner && nonOwner != address(0) && _rootHistoryExpiry != 0);

        vm.expectRevert("Ownable: caller is not the owner");

        vm.prank(nonOwner);
        scStateBridge.setRootHistoryExpiry(_rootHistoryExpiry, 0, nonOwner);
    }

    /// @notice Tests that a nonPendingOwner can't accept ownership of StateBridge
    /// @param newOwner the new owner of the contract
    function test_notOwner_acceptOwnership_reverts(address newOwner, address randomAddress)
        public
    {
        vm.assume(
            newOwner != address(0) && randomAddress != address(0) && randomAddress != newOwner
        );

        vm.prank(owner);
        scStateBridge.transferOwnership(newOwner);

        vm.expectRevert("Ownable2Step: caller is not the new owner");

        vm.prank(randomAddress);
        scStateBridge.acceptOwnership();
    }

    /// @notice Tests that ownership can't be renounced
    function test_owner_renounceOwnership_reverts() public {
        vm.expectRevert(ScrollStateBridge.CannotRenounceOwnership.selector);

        vm.prank(owner);
        scStateBridge.renounceOwnership();
    }

    /// @notice Tests that the StateBridge contract can't set the opGasLimit for sendRootOptimism to 0
    function test_setGasLimitToZero_reverts() public {
        vm.expectRevert(GasLimitZero.selector);

        vm.prank(owner);
        scStateBridge.setGasLimitPropagateRoot(0);

        vm.expectRevert(GasLimitZero.selector);

        vm.prank(owner);
        scStateBridge.setGasLimitSetRootHistoryExpiry(0);

        vm.expectRevert(GasLimitZero.selector);

        vm.prank(owner);
        scStateBridge.setGasLimitTransferOwnershipScroll(0);
    }

    receive() external payable{}
}