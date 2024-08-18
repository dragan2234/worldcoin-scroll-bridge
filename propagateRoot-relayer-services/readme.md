
# Relayer Service to Periodically Call `propagateRoot()`

This document provides a detailed investigation on how to create a relayer service that periodically calls the `propagateRoot()` function in the `ScrollStateBridge` smart contract. The goal of this service is to ensure that the latest root from the World ID Identity Manager is propagated to the Scroll network.

## Overview

The `ScrollStateBridge` contract includes a function `propagateRoot()` which is responsible for sending the latest World ID Identity Manager root to the Scroll network. This service will be designed to:

- Periodically invoke `propagateRoot()` on the smart contract.
- Use a cron job to schedule these calls.
- Ensure that the service is robust and can handle potential issues such as network failures.

## Steps to Implement the Relayer Service

### 1. Set Up Golang Environment

Ensure you have Golang installed on your machine. If not, you can download it from [golang.org](https://golang.org/).

Initialize a new Go module for the project:

```bash
mkdir ScrollWorldBridge-relayer-service
cd ScrollWorldBridge-relayer-service
go mod init github.com/ScrollWorldBridge/relayer-service
```

### 2. Install Required Packages

You will need the following packages:

- **Ethereum Go client**: To interact with the Ethereum blockchain.
- **Golang Cron**: To schedule periodic execution.

Install the necessary packages:

```bash
go get github.com/ethereum/go-ethereum
go get github.com/robfig/cron/v3
```

### 3. Interact with the Smart Contract

Create a Go file (`main.go`) to interact with the `ScrollStateBridge` contract. This file will contain the logic to call `propagateRoot()`.

```go
package main

import (
    "log"
    "math/big"
    "context"

    "github.com/ethereum/go-ethereum"
    "github.com/ethereum/go-ethereum/accounts/abi/bind"
    "github.com/ethereum/go-ethereum/common"
    "github.com/ethereum/go-ethereum/ethclient"
    "github.com/robfig/cron/v3"
)

const (
    //these should obviously be hidden 
    infuraURL         = "https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID"
    contractAddress   = "0xScrollStateBridgeContractAddress" // ScrollStateBridge contract address
    ownerPrivateKey   = "your-private-key"      // relayer's private key
)

func main() {
    client, err := ethclient.Dial(infuraURL)
    if err != nil {
        log.Fatalf("Failed to connect to the Ethereum client: %v", err)
    }

    contractAddress := common.HexToAddress(contractAddress)

    instance, err := NewScrollStateBridge(contractAddress, client)
    if err != nil {
        log.Fatalf("Failed to load contract instance: %v", err)
    }

    c := cron.New()
    _, err = c.AddFunc("*/5 * * * *", func() {
        propagateRoot(client, instance)
    })
    if err != nil {
        log.Fatalf("Failed to schedule cron job: %v", err)
    }

    c.Start()

    // Create a channel to listen for interrupt or termination signals
    sigs := make(chan os.Signal, 1)
    signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)

    // Block until a signal is received
    <-sigs

    log.Println("Shutting down...")
    c.Stop() // Stop the cron scheduler gracefully
}

func propagateRoot(client *ethclient.Client, instance *ScrollStateBridge) {
    auth, err := bind.NewTransactorWithChainID(ownerPrivateKey, nil, big.NewInt(1))
    if err != nil {
        log.Fatalf("Failed to create authorized transactor: %v", err)
    }

    tx, err := instance.PropagateRoot(auth)
    if err != nil {
        log.Printf("Failed to call propagateRoot: %v", err)
        return
    }

    log.Printf("propagateRoot transaction sent: %s", tx.Hash().Hex())
}
```

### 4. Deploy and Test the Service

Once the service is implemented:

1. **Run the Service**: Execute the Go program to start the relayer service.
2. **Monitor the Logs**: Ensure that the `propagateRoot()` function is called as scheduled and the transaction is successfully sent.

### 5. Deploying the Service in Production

- **Use Docker**: Containerize the Go application using Docker for easy deployment.
- **Set Up Monitoring**: Integrate with monitoring tools to ensure the service is running smoothly.

### Additional Considerations

- **Error Handling**: Implement more robust error handling and retries to deal with network issues.
- **Security**: Secure your private keys and sensitive data.
- **Gas Management**: Monitor and adjust gas limits as needed.