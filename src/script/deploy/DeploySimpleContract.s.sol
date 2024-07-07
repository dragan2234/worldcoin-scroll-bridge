// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {Script} from "forge-std/Script.sol";
import {SimpleContract} from "src/SimpleContract.sol";
import {console} from "forge-std/console.sol";

/// @title SimpleContract deployment script
/// @notice forge script to deploy SimpleContract.sol to Scroll
contract DeploySimpleContract is Script {
    SimpleContract public simpleContract;

    ///////////////////////////////////////////////////////////////////
    ///                            CONFIG                           ///
    ///////////////////////////////////////////////////////////////////
    string public root;
    uint256 public privateKey;

    constructor() {
        root = "your_project_root";
        privateKey = vm.envUint("PRIVATE_KEY");// Replace with your private key
    }

    function run() external {
        console.log("Starting simple contract deployment...");
        address deployerAddress = vm.addr(privateKey);

        // Log balance of deployer address
        uint256 deployerBalance = deployerAddress.balance;
        console.log("Deployer address:", deployerAddress);
        console.log("Deployer balance (wei):", deployerBalance);
        require(deployerBalance > 0, "Insufficient balance for deployment");

        vm.startBroadcast(privateKey);
            console.log("Deploying SimpleContract...");
            simpleContract = new SimpleContract(42);
            console.log("SimpleContract deployed at:", address(simpleContract));
        vm.stopBroadcast();
    }
}
