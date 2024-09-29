// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {IL2ScrollMessenger} from "@scroll-tech/contracts/L2/IL2ScrollMessenger.sol";

contract MockL2ScrollMessenger is IL2ScrollMessenger {
    address private messageSender;
    mapping(address => uint256) public nonces;
    uint256 private _nonce;

    /**
     *
     * Public View Functions *
     *
     */

    /// @notice Return the sender of a cross domain message.
    function xDomainMessageSender() external view returns (address) {
        return messageSender;
    }

    function sendMessage(address target, uint256 value, bytes calldata message, uint256 gasLimit)
        external
        payable
        override
    {
        // out of scope
        emit SentMessage(msg.sender, target, value, _nonce, gasLimit, message);
    }

    function sendMessage(
        address target,
        uint256 value,
        bytes calldata message,
        uint256 gasLimit,
        address refundAddress
    ) external payable override {
        // out of scope
        emit SentMessage(msg.sender, target, value, _nonce, gasLimit, message);
    }

    /**
     *
     * Public Mutating Functions *
     *
     */

    /// @notice execute L1 => L2 message
    /// @dev Make sure this is only called by privileged accounts.
    /// @param from The address of the sender of the message.
    /// @param to The address of the recipient of the message.
    /// @param value The msg.value passed to the message call.
    /// @param nonce The nonce of the message to avoid replay attack.
    /// @param message The content of the message.
    function relayMessage(
        address from,
        address to,
        uint256 value,
        uint256 nonce,
        bytes calldata message
    ) external {
        // Ensure the nonce is correct to avoid replay attacks
        require(nonce == nonces[from], "Invalid nonce");

        messageSender = from;

        (bool success,) = to.call(message);

        bytes32 messageHash = keccak256(abi.encodePacked(from, to, value, nonce, message));

        if (success) {
            emit RelayedMessage(messageHash);
            nonces[from]++; // Increment nonce to prevent replay
        } else {
            // If the call fails, emit a failure event
            emit FailedRelayedMessage(messageHash);
        }

        // Require the success to revert the transaction if the message relay failed
        require(success, "Message relay failed");
    }
}
