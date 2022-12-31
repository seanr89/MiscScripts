#!/bin/sh

# Error handling
set -e -u
set -o pipefail

read -p "Do you want to proceed? (y/n) " yn

case $yn in 
	y ) echo ok, we will proceed;;
	n ) echo exiting...;
		exit;;
	* ) echo invalid response;
		exit 1;;
esac

echo doing stuff...