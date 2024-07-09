#!/bin/bash

# Ensure forge is installed
if ! command -v forge &> /dev/null
then
    echo "forge could not be found. Please install foundry and try again."
    exit
fi

# List of dependencies to install
declare -a dependencies=(
    "PaulRBerg/prb-test"
    "foundry-rs/forge-std"
    "rari-capital/solmate"
    "OpenZeppelin/openzeppelin-contracts@v4.8.0"
    "OpenZeppelin/openzeppelin-contracts-upgradeable@v4.8.1"
    "fx-portal/contracts@v1.0.5"
)

# Loop through the array and install each dependency
for dep in "${dependencies[@]}"
do
   echo "Installing $dep"
   forge install "$dep" --no-commit
done

echo "All dependencies installed successfully."
