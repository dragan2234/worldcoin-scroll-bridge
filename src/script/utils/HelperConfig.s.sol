// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import {ScrollStateBridge} from "src/ScrollStateBridge.sol";
import {ScrollWorldID} from "src/ScrollWorldID.sol";
import {MockL1ScrollMessenger} from "src/mocks/MockL1ScrollMessenger.sol";
import {MockL2ScrollMessenger} from "src/mocks/MockL2ScrollMessenger.sol";
import {MockWorldIDIdentityManager} from "src/mocks/MockWorldIDIdentityManager.sol";

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

abstract contract CodeConstants {
    uint8 public constant TREE_DEPTH = 30;
    uint256 public constant INITIAL_ROOT = uint256(0x111);

    /*//////////////////////////////////////////////////////////////
                               CHAIN IDS
    //////////////////////////////////////////////////////////////*/
    uint256 public constant ETH_SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant ETH_MAINNET_CHAIN_ID = 1;
    uint256 public constant LOCAL_CHAIN_ID = 31337;
    uint256 public constant SCROLL_SEPOLIA_CHAIN_ID = 534351;
    uint256 public constant SCROLL_MAINNET_CHAIN_ID = 534352;
}

contract HelperConfig is CodeConstants, Script {
    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/
    error HelperConfig__InvalidChainId();

    /*//////////////////////////////////////////////////////////////
                                 TYPES
    //////////////////////////////////////////////////////////////*/
    struct NetworkConfig {
        address L1ScrollMessengerAddress;
        address L2ScrollMessengerAddress;
        address WorldIdentityManagerAddress;
        address ScrollWorldIDAddress;
    }

    struct RPCConfig {
        string EthRPC;
        string ScrollRPC;
    }

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    // Local network state variables
    NetworkConfig public localNetworkConfig;

    string public root = vm.projectRoot();
    string public sepoliaConfigPath =
        string.concat(root, "/src/script/config/default-sepolia-config.json");
    string public mainnetConfigPath =
        string.concat(root, "/src/script/config/default-mainnet-config.json");

    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function getConfigByChainId(uint256 chainId) public returns (NetworkConfig memory) {
        if (chainId == ETH_MAINNET_CHAIN_ID || chainId == SCROLL_MAINNET_CHAIN_ID) {
            return getMainnetEthConfig();
        } else if (chainId == ETH_SEPOLIA_CHAIN_ID || chainId == SCROLL_SEPOLIA_CHAIN_ID) {
            return getSepoliaEthConfig();
        } else if (chainId == LOCAL_CHAIN_ID) {
            return getOrCreateAnvilEthConfig();
        } else {
            revert HelperConfig__InvalidChainId();
        }
    }

    function setScrollWorldId(address worldIdAddress, uint256 chainId) public {
        if (chainId == ETH_MAINNET_CHAIN_ID || chainId == SCROLL_MAINNET_CHAIN_ID) {
            vm.writeJson(vm.toString(worldIdAddress), mainnetConfigPath, ".ScrollWorldIDAddress");
        } else if (chainId == ETH_SEPOLIA_CHAIN_ID || chainId == SCROLL_SEPOLIA_CHAIN_ID) {
            vm.writeJson(vm.toString(worldIdAddress), sepoliaConfigPath, ".ScrollWorldIDAddress");
        } else if (chainId == LOCAL_CHAIN_ID) {
            localNetworkConfig.ScrollWorldIDAddress = worldIdAddress;
        } else {
            revert HelperConfig__InvalidChainId();
        }
    }

    function getTreeDepth() public pure returns (uint8) {
        return TREE_DEPTH;
    }

    function getInitialRoot() public pure returns (uint256) {
        return INITIAL_ROOT;
    }

    /*//////////////////////////////////////////////////////////////
                                CONFIGS
    //////////////////////////////////////////////////////////////*/
    function getSepoliaEthConfig() private view returns (NetworkConfig memory) {
        string memory json = vm.readFile(sepoliaConfigPath);
        return readConfig(json);
    }

    function getMainnetEthConfig() private view returns (NetworkConfig memory) {
        string memory json = vm.readFile(mainnetConfigPath);
        return readConfig(json);
    }

    function readConfig(string memory json) private pure returns (NetworkConfig memory) {
        address l1Messenger = abi.decode(vm.parseJson(json, ".L1ScrollMessengerAddress"), (address));
        address l2Messenger = abi.decode(vm.parseJson(json, ".L2ScrollMessengerAddress"), (address));
        address identityManager =
            abi.decode(vm.parseJson(json, ".WorldIdentityManagerAddress"), (address));
        address scrollWorldId = abi.decode(vm.parseJson(json, ".ScrollWorldIDAddress"), (address));
        return NetworkConfig({
            L1ScrollMessengerAddress: l1Messenger,
            L2ScrollMessengerAddress: l2Messenger,
            WorldIdentityManagerAddress: identityManager,
            ScrollWorldIDAddress: scrollWorldId
        });
    }

    function getRPCs(uint256 chainId) public view returns (RPCConfig memory) {
        if (chainId == ETH_MAINNET_CHAIN_ID || chainId == SCROLL_MAINNET_CHAIN_ID) {
            string memory ethRPC = vm.envString("MAINNET_RPC_URL");
            string memory scrollRpc = vm.envString("SCROLL_MAINNET_RPC_URL");
            return RPCConfig({EthRPC: ethRPC, ScrollRPC: scrollRpc});
        } else if (chainId == ETH_SEPOLIA_CHAIN_ID || chainId == SCROLL_SEPOLIA_CHAIN_ID) {
            string memory ethRPC = vm.envString("SEPOLIA_RPC_URL");
            string memory scrollRpc = vm.envString("SCROLL_TESTNET_RPC_URL");
            return RPCConfig({EthRPC: ethRPC, ScrollRPC: scrollRpc});
        } else if (chainId == LOCAL_CHAIN_ID) {
            return RPCConfig({EthRPC: "http://127.0.0.1:8545", ScrollRPC: "http://127.0.0.1:8545"});
        } else {
            revert HelperConfig__InvalidChainId();
        }
    }

    /*//////////////////////////////////////////////////////////////
                              LOCAL CONFIG
    //////////////////////////////////////////////////////////////*/
    function getOrCreateAnvilEthConfig() private returns (NetworkConfig memory) {
        // Check to see if we set an active network config
        if (localNetworkConfig.L1ScrollMessengerAddress != address(0)) {
            return localNetworkConfig;
        }

        console.log(unicode"⚠️ You have deployed a mock conract!");
        console.log("Make sure this was intentional");
        vm.startBroadcast();

        // Deploy the Mock WorldIdentityManager, that provides the root
        MockWorldIDIdentityManager mockWorldIDIdentityManager =
            new MockWorldIDIdentityManager(INITIAL_ROOT);

        // Deploy the L2 Messenger (used by both L1 and L2)
        MockL2ScrollMessenger l2Messenger = new MockL2ScrollMessenger();

        // Deploy the L1 Messenger, which will interact with the L2 Messenger
        MockL1ScrollMessenger l1Messenger = new MockL1ScrollMessenger(address(l2Messenger));

        vm.stopBroadcast();

        localNetworkConfig = NetworkConfig({
            L1ScrollMessengerAddress: address(l1Messenger),
            L2ScrollMessengerAddress: address(l2Messenger),
            WorldIdentityManagerAddress: address(mockWorldIDIdentityManager),
            ScrollWorldIDAddress: address(0)
        });

        return localNetworkConfig;
    }
}
