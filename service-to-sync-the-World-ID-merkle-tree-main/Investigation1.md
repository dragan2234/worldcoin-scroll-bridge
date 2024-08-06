### Node.js Script Example for Sync Service

A Node.js script can be used to periodically fetch and propagate the latest Merkle tree root. Here’s a simple outline of what such a script might look like:

1. *Fetch the Latest Root*: Interact with the Ethereum smart contract to get the latest Merkle tree root.
2. *Propagate the Root*: Send the fetched root to the L2 network using a cross-domain messaging mechanism.

### Example Script

Below is an example of a Node.js script for the root fetching and propagation service:

```javascript
const { ethers } = require('ethers');
const { CrossDomainMessenger } = require('@eth-optimism/sdk'); // Adjust according to your L2 solution

// Set up your provider and contracts
const l1Provider = new ethers.providers.JsonRpcProvider('https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID');
const l2Provider = new ethers.providers.JsonRpcProvider('https://optimism-mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID');
const wallet = new ethers.Wallet('YOUR_PRIVATE_KEY', l1Provider);

// Contract addresses and ABIs
const worldIdIdentityManagerAddress = '0xYourWorldIdIdentityManagerAddress';
const worldIdIdentityManagerABI = [ /* ABI for WorldIdIdentityManager */ ];

const l1StateBridgeAddress = '0xYourL1StateBridgeAddress';
const l1StateBridgeABI = [ /* ABI for L1 State Bridge */ ];

const worldIdIdentityManager = new ethers.Contract(worldIdIdentityManagerAddress, worldIdIdentityManagerABI, wallet);
const l1StateBridge = new ethers.Contract(l1StateBridgeAddress, l1StateBridgeABI, wallet);

// Function to fetch and propagate the latest root
async function fetchAndPropagateRoot() {
    try {
        // Fetch the latest root from the WorldIdIdentityManager
        const latestRoot = await worldIdIdentityManager.latestRoot();
        console.log('Latest Merkle Tree Root:', latestRoot);

        // Propagate the root to the L2 network using CrossDomainMessenger
        const messenger = new CrossDomainMessenger({
            l1SignerOrProvider: wallet,
            l2Provider: l2Provider,
            l1MessengerAddress: '0xYourL1CrossDomainMessengerAddress' // Adjust accordingly
        });

        const tx = await messenger.sendMessage(
            '0xYourL2StateBridgeAddress', // Target L2 contract address
            l1StateBridge.interface.encodeFunctionData('receiveRoot', [latestRoot]),
            { gasLimit: 2000000 }
        );

        console.log('Root propagation transaction sent:', tx.hash);
        await tx.wait();
        console.log('Root propagated successfully');
    } catch (error) {
        console.error('Error in fetchAndPropagateRoot:', error);
    }
}

// Schedule the fetchAndPropagateRoot function to run periodically
const interval = 60 * 60 * 1000; // Every hour
setInterval(fetchAndPropagateRoot, interval);

// Run the function immediately
fetchAndPropagateRoot();
```
### Key Components

1. *Provider Setup*: Connect to Ethereum and L2 network providers.
2. *Contract Interactions*: Use ethers.js to interact with the smart contracts on Ethereum.
3. *Cross-Domain Messaging*: Use the appropriate messaging protocol for L1 to L2 communication.
4. *Scheduler*: Use setInterval to run the fetch and propagate function periodically.

### Security Considerations

1. *Environment Variables*: Store sensitive information like private keys and API keys in environment variables, not directly in the code.
2. *Error Handling*: Implement robust error handling and logging to monitor the script’s performance.
3. *Audits*: Ensure that your contracts and scripts undergo thorough security audits.

By developing and deploying this Node.js script, you can automate the process of syncing the World ID Merkle tree, ensuring that the L2 network remains updated with the latest root for accurate proof verification.