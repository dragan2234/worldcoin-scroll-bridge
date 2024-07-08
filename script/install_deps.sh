#!/bin/bash

# Ensure forge is installed
if ! command -v forge &> /dev/null
then
    echo "forge could not be found. Please install foundry and try again."
    exit
fi

# List of dependencies to install
declare -a dependencies=(
    "prb/test"
    "foundry-rs/forge-std"
    "rari-capital/solmate"
    "OpenZeppelin/openzeppelin-contracts"
    "OpenZeppelin/openzeppelin-contracts-upgradeable"
    "fx-portal/contracts"
)

# Loop through the array and install each dependency
for dep in "${dependencies[@]}"
do
   echo "Installing $dep"
   forge install "$dep" --no-commit
done

echo "All dependencies installed successfully."
