#!/bin/sh

# Error handling
set -e -u
set -o pipefail

echo "Script Started"	# This is a comment, too!


if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
fi

## First refresh local server package index
echo "Updating Local Packages"
sudo apt update

## Node Checks and Install
if [ "whereis node | grep ' ' -ic" == 1]; then
        echo "node is installed, skipping..."
    else
        echo "download node"
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

        # #Active NVM
        echo "installing nvm"
        . ~/.nvm/nvm.sh

        echo "installing node"
        # nvm install node
        nvm install 16.15.0

        node -e "console.log('Running Node.js ' + process.version)"
fi

# # Postgres
if [ "whereis psql | grep ' ' -ic" == 1 ]; then
        echo "psql is installed, skipping..."
    else
        echo "installing psql..."
        sudo apt install postgresql postgresql-contrib
fi