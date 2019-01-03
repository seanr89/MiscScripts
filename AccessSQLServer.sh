#!/bin/bash
set -e -u #Exit immediately if a command exits with a non-zero status.

if [ $# -eq 0 ]
  then
    echo "No arguments supplied";
    exit 1;
fi

containerID=$1
sqlPassword=$2

docker exec -it $containerID /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $sqlPassword

echo "SQL Server Accessed!"
