// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {WorldIDBridge} from "./abstract/WorldIDBridge.sol";
import {IL2ScrollMessenger} from "@scroll-tech/contracts/L2/IL2ScrollMessenger.sol";
import {IScrollWorldID} from "./interfaces/IScrollWorldID.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title Scroll World ID Bridge
/// @author Worldcoin
/// @notice A contract that manages the root history of the Semaphore identity merkle tree on
///         Scroll.
/// @dev This contract is deployed on Optimism and is called by the L1 Proxy contract for each new
///      root insertion.
contract ScrollWorldID is WorldIDBridge, IScrollWorldID, Ownable {
    ///////////////////////////////////////////////////////////////////
    ///                           STORAGE                           ///
    ///////////////////////////////////////////////////////////////////

    /// @notice The address of corresponding `L2ScrollMessenger` contract.
    address public immutable messenger;

    /// @notice The address of the scroll sepolia bridge address
    address public scroll_bridge;

    ///////////////////////////////////////////////////////////////////////////////
    ///                                  ERRORS                                 ///
    ///////////////////////////////////////////////////////////////////////////////

    /// @notice Emitted when the cross sender is not controller
    ///
    error ErrorSenderNotScrollBridge();

    ///////////////////////////////////////////////////////////////////////////////
    ///                                CONSTRUCTION                             ///
    ///////////////////////////////////////////////////////////////////////////////

    /// @notice Initializes the contract the depth of the associated merkle tree
    ///         and the L2ScrollMessenger contract
    /// @param _treeDepth The depth of the WorldID Semaphore merkle tree.
    constructor(uint8 _treeDepth, address _messenger) WorldIDBridge(_treeDepth) {
        messenger = _messenger;
    }

    ///////////////////////////////////////////////////////////////////////////////
    ///                               ROOT MIRRORING                            ///
    ///////////////////////////////////////////////////////////////////////////////

    /// @notice This function is called by the state bridge contract when it forwards a new root to
    ///         the bridged WorldID.
    /// @dev    This function can revert if Scroll's ScrollMessenger stops processing proofs
    ///
    /// @param newRoot The value of the new root.
    ///
    /// @custom:reverts CannotOverwriteRoot If the root already exists in the root history.
    /// @custom:reverts string If the caller is not the controller
    function receiveRoot(uint256 newRoot) external virtual {
        if (scroll_bridge != IL2ScrollMessenger(messenger).xDomainMessageSender()) {
            revert ErrorSenderNotScrollBridge();
        }
        _receiveRoot(newRoot);
    }

    ///////////////////////////////////////////////////////////////////////////////
    ///                              DATA MANAGEMENT                            ///
    ///////////////////////////////////////////////////////////////////////////////

    /// @notice Sets the amount of time it takes for a root in the root history to expire.
    ///
    /// @param expiryTime The new amount of time it takes for a root to expire.
    ///
    /// @custom:reverts string If the caller is not the owner.
    function setRootHistoryExpiry(uint256 expiryTime) public virtual override onlyOwner {
        _setRootHistoryExpiry(expiryTime);
    }

    /// @notice Updates controller address.
    ///
    /// @param _bridge The address of the scroll bridge
    ///
    /// @custom:reverts string If the caller is not the owner.
    function setScrollBridge(address _bridge) public onlyOwner {
        scroll_bridge = _bridge;
    }
}
