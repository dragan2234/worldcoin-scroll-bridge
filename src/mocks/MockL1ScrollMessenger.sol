// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {IScrollMessenger} from "@scroll-tech/contracts/libraries/IScrollMessenger.sol";
import {IL2ScrollMessenger} from "@scroll-tech/contracts/L2/IL2ScrollMessenger.sol";

contract MockL1ScrollMessenger is IScrollMessenger {
    address private messageSender;
    IL2ScrollMessenger private l2Messenger;
    uint256 private nonce;

    constructor(address _l2Messenger) {
        l2Messenger = IL2ScrollMessenger(_l2Messenger);
    }

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
        // set message sender as xDomainMessageSender
        messageSender = msg.sender;
        // Simulate sending a message to L2 messenger
        l2Messenger.relayMessage(messageSender, target, value, nonce, message);
        // increment message nonce
        nonce++;
        emit SentMessage(msg.sender, target, value, nonce, gasLimit, message);
    }

    function sendMessage(
        address target,
        uint256 value,
        bytes calldata message,
        uint256 gasLimit,
        address refundAddress
    ) external payable override {
        // set message sender as xDomainMessageSender
        messageSender = msg.sender;
        // Simulate sending a message to L2 messenger
        l2Messenger.relayMessage(messageSender, target, value, nonce, message);
        // increment nonce
        nonce++;
        emit SentMessage(msg.sender, target, value, nonce, gasLimit, message);
    }
}
