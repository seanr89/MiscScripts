#!/bin/bash
set -e -u #Exit immediately if a command exits with a non-zero status.

if [ $# -eq 0 ]
  then
    echo "No arguments supplied";
    exit 1;
fi

#Example commands to create a database, insert a table and insert a number of rows
/opt/mssql-tools/bin/sqlcmd -S $1,1433 -U SA -P Microsoft123! -Q "CREATE DATABASE Voting"
/opt/mssql-tools/bin/sqlcmd -S $1,1433 -U SA -P Microsoft123! -d Voting -Q "CREATE TABLE Voting (Name varchar(32), Number int)"
/opt/mssql-tools/bin/sqlcmd -S $1,1433 -U SA -P Microsoft123! -d Voting -Q "INSERT INTO Voting (Name, Number) VALUES ('Option1', 0)"
/opt/mssql-tools/bin/sqlcmd -S $1,1433 -U SA -P Microsoft123! -d Voting -Q "INSERT INTO Voting (Name, Number) VALUES ('Option2', 0)"