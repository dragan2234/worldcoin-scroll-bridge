// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {ScrollStateBridge} from "src/ScrollStateBridge.sol";
import {ScrollWorldID} from "src/ScrollWorldID.sol";
import {MockWorldIDIdentityManager} from "src/mocks/MockWorldIDIdentityManager.sol";
import {Deployer} from "src/script/deploy/Deployer.s.sol";
import {HelperConfig} from "src/script/utils/HelperConfig.s.sol";
import {PRBTest} from "@prb/test/PRBTest.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {console} from "forge-std/console.sol";

/// @title State Bridge Test
/// @author Worldcoin
/// @notice A test contract for StateBridge.sol
contract ScrollStateBridgeTest is PRBTest, StdCheats {
    ///////////////////////////////////////////////////////////////////
    ///                        STORAGE CONFIG                       ///
    ///////////////////////////////////////////////////////////////////

    /// @notice emitted if there is no CrossDomainMessenger contract deployed on the fork
    error invalidCrossDomainMessengerFork();

    Deployer public deployer;
    ScrollStateBridge public scStateBridge;
    ScrollWorldID public scWorldID;

    uint32 public scGasLimit;

    address public scWorldIDAddress;

    address public owner;

    /// @notice The address of the ScrollWorldID contract on any Scroll Blockchain
    address public scrollWorldIDAddress;

    /// @notice The address of the Scroll State Bridge contract on L1
    address public scrollStateBridgeAddress;

    /// @notice address for Scroll Blockchain chain Ethereum mainnet L1CrossDomainMessenger contract
    address public scrollCrossDomainMessengerAddressL1;

    /// @notice address for Scroll Blockchain chain Ethereum mainnet L2CrossDomainMessenger contract
    address public scrollCrossDomainMessengerAddressL2;

    /// @notice address of mockWorldIdManager
    address public mockWorldIDIdentityManagerAddress;

    uint256 public sampleRoot;

    uint8 public sampleDepth;

    uint256 public scrollFork;

    uint256 public ethFork;

    ///////////////////////////////////////////////////////////////////
    ///                            EVENTS                           ///
    ///////////////////////////////////////////////////////////////////

    /// @notice Emitted when the ownership transfer of ScrollStateBridge is started (OZ Ownable2Step)
    event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);

    /// @notice Emitted when the ownership transfer of ScrollStateBridge is accepted (OZ Ownable2Step)
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // @notice Emitted when the the StateBridge sends a root to the ScrollWorldID contract
    /// @param root The root sent to the ScrollWorldID contract on the Scroll Blockchain chain
    event RootPropagated(uint256 root);

    /// @notice Emitted when the the StateBridge gives ownership of the ScrollWorldID contract
    /// to the WorldID Identity Manager contract away
    /// @param previousOwner The previous owner of the ScrollWorldID contract
    /// @param newOwner The new owner of the ScrollWorldID contract
    /// @param isLocal Configures the `isLocal` contract variable.
    event OwnershipTransferredScroll(
        address indexed previousOwner, address indexed newOwner, bool isLocal
    );

    /// @notice Emitted when the the StateBridge sets the root history expiry for ScrollWorldID and PolygonWorldID
    /// @param rootHistoryExpiry The new root history expiry
    event SetRootHistoryExpiry(uint256 rootHistoryExpiry);

    /// @notice Emitted when the the StateBridge sets the gas limit for sendRootOp
    /// @param _scGasLimit The new opGasLimit for sendRootOp
    event SetGasLimitPropagateRoot(uint32 _scGasLimit);

    /// @notice Emitted when the the StateBridge sets the gas limit for SetRootHistoryExpiryt
    /// @param _scGasLimit The new opGasLimit for SetRootHistoryExpiryScroll
    event SetGasLimitSetRootHistoryExpiry(uint32 _scGasLimit);

    /// @notice Emitted when the the StateBridge sets the gas limit for transferOwnershipOp
    /// @param _scGasLimit The new opGasLimit for transferOwnershipScroll
    event SetGasLimitTransferOwnershipScroll(uint32 _scGasLimit);

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
        deployer = new Deployer();
        HelperConfig helper = deployer.getHelperConfig();

        /// @notice Create a fork of the Scroll network
        string memory scrollRPC = helper.getRPCs(block.chainid).ScrollRPC;
        scrollFork = vm.createSelectFork(scrollRPC);

        // get l2 messenger
        scrollCrossDomainMessengerAddressL2 =
            helper.getConfigByChainId(block.chainid).L2ScrollMessengerAddress;
        vm.makePersistent(scrollCrossDomainMessengerAddressL2);

        /// @notice Deploy scroll world ID on scroll fork;
        scWorldID = deployer.deployScrollWorldID();
        scWorldIDAddress = address(scWorldID);
        vm.makePersistent(scWorldIDAddress);

        /// @notice switch to eth
        string memory ethRPC = helper.getRPCs(block.chainid).EthRPC;

        if (compareStrings(ethRPC, scrollRPC)) {
            ethFork = vm.createSelectFork(ethRPC);
        } else {
            ethFork = scrollFork;
        }

        // get l1 messenger
        scrollCrossDomainMessengerAddressL1 =
            helper.getConfigByChainId(block.chainid).L1ScrollMessengerAddress;

        mockWorldIDIdentityManagerAddress =
            helper.getConfigByChainId(block.chainid).WorldIdentityManagerAddress;

        vm.makePersistent(scrollCrossDomainMessengerAddressL1);

        /// @notice Deploy scroll state bridger on eth fork;
        scStateBridge = deployer.deployScrollStateBridge();
        scrollStateBridgeAddress = address(scStateBridge);

        // get configuration
        sampleRoot = helper.getInitialRoot();
        sampleDepth = helper.getTreeDepth();

        // set owner
        owner = scStateBridge.owner();
    }

    ///////////////////////////////////////////////////////////////////
    ///                           MODFIER                          ///
    ///////////////////////////////////////////////////////////////////

    modifier ownershipTransferredScroll() {
        vm.selectFork(scrollFork);
        vm.prank(owner);
        // transfer ownership to the scroll State bridge
        address newOwner = address(scStateBridge);
        bool isLocal = false;
        scWorldID.transferOwnership(newOwner, isLocal);
        assertEq(scWorldID.owner(), address(scStateBridge));
        _;
    }

    ///////////////////////////////////////////////////////////////////
    ///                           SUCCEEDS                          ///
    ///////////////////////////////////////////////////////////////////

    function test_propagateRoot_suceeds() public ownershipTransferredScroll {
        vm.selectFork(ethFork);
        uint256 root = MockWorldIDIdentityManager(mockWorldIDIdentityManagerAddress).latestRoot();
        vm.expectEmit(true, true, true, true);
        emit RootPropagated(root);
        vm.prank(owner);
        vm.deal(owner, 5 ether);
        uint256 amount = 0.4 ether; // Define the Ether amount you want to attach
        scStateBridge.propagateRoot{value: amount}(msg.sender);
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

    /// @notice tests whether the StateBridge contract can transfer ownership of the ScrollWorldID contract
    /// @param newOwner The new owner of the ScrollWorldID contract (foundry fuzz)
    function test_owner_transferOwnershipScroll_succeeds(address newOwner)
        public
        ownershipTransferredScroll
    {
        // Switch to the Ethereum fork to interact with scStateBridge
        vm.selectFork(ethFork);
        vm.assume(newOwner != address(0));

        // Prepare for the event emission
        vm.expectEmit(true, true, true, true);
        emit OwnershipTransferredScroll(owner, newOwner, true);

        // Perform the ownership transfer on the Ethereum fork and attach Ether
        vm.prank(owner); // Simulate the transaction from the owner
        vm.deal(owner, 5 ether);
        scStateBridge.transferOwnershipScroll{value: 1 ether}(newOwner, msg.sender, true);
    }

    /// @notice tests whether the StateBridge contract can set root history expiry on Optimism and Polygon
    /// @param _rootHistoryExpiry The new root history expiry for ScrollWorldID and PolygonWorldID
    function test_owner_setRootHistoryExpiry_succeeds(uint256 _rootHistoryExpiry)
        public
        ownershipTransferredScroll
    {
        // Switch to the Ethereum fork to interact with scStateBridge
        vm.selectFork(ethFork);
        vm.expectEmit(true, true, true, true);
        emit SetRootHistoryExpiry(_rootHistoryExpiry);
        vm.prank(owner);
        uint256 amount = 0.4 ether; // Define the Ether amount you want to attach
        vm.deal(owner, amount);
        scStateBridge.setRootHistoryExpiry{value: amount}(_rootHistoryExpiry, msg.sender);
    }

    /// @notice tests whether the StateBridge contract can set the opGasLimit for sendRootOptimism
    /// @param _scGasLimit The new opGasLimit for sendRootOptimism
    function test_owner_setGasLimitPropagateRoot_succeeds(uint32 _scGasLimit) public {
        vm.assume(_scGasLimit != 0);
        vm.expectEmit(true, true, true, true);
        emit SetGasLimitPropagateRoot(_scGasLimit);
        vm.prank(owner);
        scStateBridge.setGasLimitPropagateRoot(_scGasLimit);
    }

    /// @notice tests whether the StateBridge contract can set the opGasLimit for SetRootHistoryExpirytimism
    /// @param _scGasLimit The new opGasLimit for SetRootHistoryExpirytimism
    function test_owner_setGasLimitSetRootHistoryExpiry_succeeds(uint32 _scGasLimit) public {
        vm.assume(_scGasLimit != 0);
        vm.expectEmit(true, true, true, true);
        emit SetGasLimitSetRootHistoryExpiry(_scGasLimit);
        vm.prank(owner);
        scStateBridge.setGasLimitSetRootHistoryExpiry(_scGasLimit);
    }

    /// @notice tests whether the StateBridge contract can set the opGasLimit for transferOwnerShipScroll
    /// @param _scGasLimit The new opGasLimit for transferOwnerShipScroll
    function test_owner_setGasLimitTransferOwnershipSc_succeeds(uint32 _scGasLimit) public {
        vm.assume(_scGasLimit != 0);
        vm.expectEmit(true, true, true, true);
        emit SetGasLimitTransferOwnershipScroll(_scGasLimit);
        vm.prank(owner);
        scStateBridge.setGasLimitTransferOwnershipScroll(_scGasLimit);
    }

    // ///////////////////////////////////////////////////////////////////
    // ///                           REVERTS                           ///
    // ///////////////////////////////////////////////////////////////////

    /// @notice Tests that the StateBridge constructor params can't be set to the zero address
    function test_cannotInitializeConstructorWithZeroAddresses_reverts() public {
        vm.expectRevert(AddressZero.selector);
        scStateBridge = new ScrollStateBridge(
            address(0), scrollWorldIDAddress, scrollCrossDomainMessengerAddressL1
        );

        vm.expectRevert(AddressZero.selector);
        scStateBridge =
            new ScrollStateBridge(scWorldIDAddress, address(0), scrollCrossDomainMessengerAddressL1);

        vm.expectRevert(AddressZero.selector);
        scStateBridge = new ScrollStateBridge(scWorldIDAddress, scrollWorldIDAddress, address(0));
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
    function test_owner_transferOwnershipSc_toZeroAddress_reverts()
        public
        ownershipTransferredScroll
    {
        //   Switch to the Ethereum fork to interact with scStateBridge
        vm.selectFork(ethFork);
        vm.expectRevert(AddressZero.selector);
        vm.prank(owner);
        vm.deal(owner, 5 ether);
        scStateBridge.transferOwnershipScroll{value: 0.04 ether}(address(0), msg.sender, true);
    }

    /// @notice tests that the StateBridge contract's ownership can't be changed by a non-owner
    /// @param newOwner The new owner of the StateBridge contract (foundry fuzz)
    function test_notOwner_transferOwnershipOp_reverts(address nonOwner, address newOwner)
        public
        ownershipTransferredScroll
    {
        //   Switch to the Ethereum fork to interact with scStateBridge
        vm.selectFork(ethFork);
        vm.assume(nonOwner != owner && newOwner != address(0));
        vm.expectRevert("Ownable: caller is not the owner");
        vm.prank(nonOwner);
        vm.deal(nonOwner, 5 ether);
        scStateBridge.transferOwnershipScroll{value: 0.4 ether}(newOwner, msg.sender, true);
    }

    /// @notice tests whether the StateBridge contract can set root history expiry on Scroll
    /// @param _rootHistoryExpiry The new root history expiry for ScrollWorldID
    function test_notOwner_SetRootHistoryExpiry_reverts(
        address nonOwner,
        uint256 _rootHistoryExpiry
    ) public ownershipTransferredScroll {
        // Switch to the Ethereum fork to interact with scStateBridge
        vm.selectFork(ethFork);
        vm.assume(nonOwner != owner && nonOwner != address(0) && _rootHistoryExpiry != 0);
        vm.expectRevert("Ownable: caller is not the owner");
        vm.prank(nonOwner);
        vm.deal(nonOwner, 5 ether);
        uint256 amount = 0.4 ether; // Define the Ether amount you want to attach
        scStateBridge.setRootHistoryExpiry{value: amount}(_rootHistoryExpiry, msg.sender);
    }

    /// @notice Tests that a nonPendingOwner can't accept ownership of StateBridge
    /// @param newOwner the new owner of the contract
    /// @param randomAddress a random address
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

    function compareStrings(string memory a, string memory b) public pure returns (bool) {
        return keccak256(abi.encodePacked(a)) != keccak256(abi.encodePacked(b));
    }
}
