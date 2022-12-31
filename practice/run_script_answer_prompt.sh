#!/bin/sh

# Error handling added
set -e -u
set -o pipefail

echo "This script is about to run another script with automated yes"
yes | ./yes_no_script.sh
echo "This script has just run another script."