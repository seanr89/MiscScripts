#!/bin/bash

# Script to create a set of aliases

# Define the aliases
declare -A aliases=(
  ["ll"]="ls -lha"
  ["gcm"]="git commit -m"
  ["gco"]="git checkout"
  ["gst"]="git status"
  ["gp"]="git push"
  ["gpl"]="git pull"
  ["mkd"]="mkdir -p"
  ["rmd"]="rm -rf"
  ["c"]="clear"
)

# Function to add an alias
add_alias() {
  local alias_name="$1"
  local alias_command="$2"

  if alias "$alias_name" &> /dev/null; then
    echo "Alias '$alias_name' already exists."
  else
    echo "alias $alias_name='$alias_command'" >> ~/.bashrc
    if [ $? -eq 0 ]; then
      echo "Alias '$alias_name' added successfully."
    else
      echo "Error adding alias '$alias_name'."
    fi
  fi
}

# Add each alias
for alias_name in "${!aliases[@]}"; do
  add_alias "$alias_name" "${aliases[$alias_name]}"
done

# Source the .bashrc file to apply the changes
source ~/.bashrc

echo "Alias creation process completed."