#!/bin/bash

#Script to execute and run a sqlserver linux version

echo "Executing script!"

if [ $# -gt 0 ]; then
    echo "Your command line contains $# arguments"

    containerName=$1;
    #echo "containerName is $containerName"

    command=`docker run -d --name $containerName -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=P@55w0rd' -e 'MSSQL_PID=Developer' -p 1433:1433 microsoft/mssql-server-linux:2017-latest`
    echo $command
else
    echo "Your command line contains no arguments"
fi
