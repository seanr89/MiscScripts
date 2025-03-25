#!/bin/bash

# Script to set up a new PC with essential tools and configurations

# Update package lists
sudo apt-get update

# Install dependencies
sudo apt-get install -y wget apt-transport-https ca-certificates gnupg

# Add Microsoft's package signing key
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
sudo mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/

# Add Microsoft's package repository
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-$(lsb_release -rs)-prod $(lsb_release -cs) main"

# Update package lists again
sudo apt-get update

# Install the latest .NET SDK
sudo apt-get install -y dotnet-sdk-$(dotnet --list-sdks | awk '{print $1}' | sort -V | tail -n 1)