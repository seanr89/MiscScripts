#!/bin/sh

# Error handling
set -e -u
set -o pipefail

echo "This script is about to run another script."
sh ./ExecutableFileVersionChecker.sh
echo "This script has just run another script."