#!/bin/sh

set -e -u #Exit immediately if a command exits with a non-zero status.

echo "Executing script!"

docker run --name postgresql \
    -e POSTGRES_USER=myusername \
    -e POSTGRES_PASSWORD=mypassword \
    -p 5432:5432 \
    -v /data:/var/lib/postgresql/data \
    -d postgres

echo "App Complete!"