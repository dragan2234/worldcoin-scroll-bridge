// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Script} from "forge-std/Script.sol";
import {ScrollWorldID} from "src/ScrollWorldID.sol";
import {console} from "forge-std/console.sol";

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

    uint8 public treeDepth = uint8(30);

    function run() external {
        console.log("Starting deployment script..."); // Add this log
        address deployerAddress = vm.addr(privateKey);

        // Log balance of deployer address
        uint256 deployerBalance = deployerAddress.balance;
        console.log("Deployer address:", deployerAddress);
        console.log("Deployer balance (wei):", deployerBalance);
        require(deployerBalance > 0, "Insufficient balance for deployment");

        vm.startBroadcast(privateKey);
        console.log("Deploying ScrollWorldID...");
        scrollWorldID = new ScrollWorldID(treeDepth);
        console.log("ScrollWorldID deployed at:", address(scrollWorldID));
        vm.stopBroadcast();
    }
}
