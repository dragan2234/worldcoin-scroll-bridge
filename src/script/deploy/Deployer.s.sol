// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

/// @dev Demo deployments
import {Script} from "forge-std/Script.sol";
import {ScrollStateBridge} from "src/ScrollStateBridge.sol";
import {ScrollWorldID} from "src/ScrollWorldID.sol";
import {HelperConfig} from "src/script/utils/HelperConfig.s.sol";
import {console2} from "forge-std/console2.sol";

/// @title Scroll State Bridge deployment script
/// @notice forge script to deploy StateBridge.sol on Scroll
/// @author Worldcoin
/// @dev Can be executed by running `make mock`, `make local-mock`, `make deploy` or `make deploy-testnet`.
contract Deployer is Script {
    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/
    error DeployScript__ScrollWorldIdNotFound();

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    // HelperConfig public helperConfig;
    address public helperConfigAddress;

    ///////////////////////////////////////////////////////////////////
    ///                            FUNCTIONS                           ///
    ///////////////////////////////////////////////////////////////////

    constructor() {
        HelperConfig helperConfig = new HelperConfig();
        helperConfigAddress = address(helperConfig);
        vm.makePersistent(helperConfigAddress);
    }

    function deployScrollWorldID() public returns (ScrollWorldID) {
        HelperConfig helperConfig = HelperConfig(helperConfigAddress);
        address l2ScrollMessenger =
            helperConfig.getConfigByChainId(block.chainid).L2ScrollMessengerAddress;
        uint8 treeDepth = helperConfig.getTreeDepth();

        vm.startBroadcast();
        ScrollWorldID scrollWorldID = new ScrollWorldID(treeDepth, l2ScrollMessenger);
        vm.stopBroadcast();
        helperConfig.setScrollWorldId(address(scrollWorldID), block.chainid);
        return scrollWorldID;
    }

    function deployScrollStateBridge() public returns (ScrollStateBridge) {
        HelperConfig helperConfig = HelperConfig(helperConfigAddress);

        address worldIdManager =
            helperConfig.getConfigByChainId(block.chainid).WorldIdentityManagerAddress;
        address l1Messenger =
            helperConfig.getConfigByChainId(block.chainid).L1ScrollMessengerAddress;
        address scrollWorldIDAddress =
            helperConfig.getConfigByChainId(block.chainid).ScrollWorldIDAddress;

        if (scrollWorldIDAddress == address(0)) {
            revert DeployScript__ScrollWorldIdNotFound();
        }

        vm.startBroadcast();
        ScrollStateBridge bridge =
            new ScrollStateBridge(worldIdManager, scrollWorldIDAddress, l1Messenger);
        vm.stopBroadcast();

        return bridge;
    }

    function getHelperConfig() public view returns (HelperConfig) {
        HelperConfig helperConfig = HelperConfig(helperConfigAddress);
        return helperConfig;
    }
}
