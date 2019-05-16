#!/bin/bash

set -euo pipefail

echo USERNAME=azureuser
echo PASSWORD=$(openssl rand -base64 32)

#Create a VM - will take a couple of minutes
echo az vm create \
  --name myVM \
  --resource-group f79050f1-1bc3-4fb4-8044-f8225e6ef572 \
  --image Win2016Datacenter \
  --size Standard_DS2_v2 \
  --location eastus \
  --admin-username $USERNAME \
  --admin-password $PASSWORD

  # need to add a wait to check

  #Check the VM
  echo az vm get-instance-view \
  --name myVM \
  --resource-group f79050f1-1bc3-4fb4-8044-f8225e6ef572 \
  --output table

  #Confirm nginx - will take a couple of minutes
  echo az vm extension set \
  --resource-group f79050f1-1bc3-4fb4-8044-f8225e6ef572 \
  --vm-name myVM \
  --name customScript \
  --publisher Microsoft.Azure.Extensions \
  --settings "{'fileUris':['https://raw.githubusercontent.com/MicrosoftDocs/mslearn-welcome-to-azure/master/configure-nginx.sh']}" \
  --protected-settings "{'commandToExecute': './configure-nginx.sh'}"