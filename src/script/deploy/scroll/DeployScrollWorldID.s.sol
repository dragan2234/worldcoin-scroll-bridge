// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Script} from "forge-std/Script.sol";
import {ScrollWorldID} from "src/ScrollWorldID.sol";

/// @title Scroll World ID deployment script
/// @notice forge script to deploy ScrollWorldID.sol to Scroll
/// @dev Make sure to set your .env variables correctly
contract DeployScrollWorldID is Script {
    ScrollWorldID public scrollWorldID;

    ///////////////////////////////////////////////////////////////////
    ///                            CONFIG                           ///
    ///////////////////////////////////////////////////////////////////
    string public root = vm.projectRoot();
    uint256 public privateKey = vm.envUint("PRIVATE_KEY");
    address public l2ScrollMessenger = vm.envAddress("SCROLL_L2_MESSENGER_ADDRESS");

    uint8 public treeDepth = uint8(30);

    function run() external {
        vm.startBroadcast(privateKey);

        scrollWorldID = new ScrollWorldID(treeDepth, l2ScrollMessenger);

        vm.stopBroadcast();
    }
}
