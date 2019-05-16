#!/bin/bash
set -e -u #Exit immediately if a command exits with a non-zero status.

if [ $# -eq 0 ]
  then
    echo "No arguments supplied";
    exit 1;
fi

#
if [ -z "$1" ]
then
    echo "no resource Group name provided";
    exit 1;
else
    resourceGroup=$1;
fi

echo $resourceGroup

# az group deployment create --resource-group $resourceGroup \
#     --template-uri https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/docker-simple-on-ubuntu/azuredeploy.json

# Wait for the VMs to be provisioned
while [[$(az vm list --resource-group $resourceGroup --query "length([?provisioningState=='Succeeded'])") != 3]];do
    echo "The VM template are still not provisioned. Trying again in 20 seconds."
    sleep 20
done
echo "The VM template has been provisioned."


function createResourceGroup()
{
    az group create -n $resourceGroup -l ukwest
}