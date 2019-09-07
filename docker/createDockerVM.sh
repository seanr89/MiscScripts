#!/bin/bash
set -e -u #Exit immediately if a command exits with a non-zero status.

if [ $# -gt 0 ]; then
    echo "Your command line contains $# arguments"

    vmName=$1;

    #Script to create a Docker based VM using VirtualBox
    command=`docker-machine create --driver virtualbox $vmName`
    echo $command
else
    echo "Your command line contains no arguments"
fi

