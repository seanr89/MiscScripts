#!/bin/bash

# Script to delete node_modules and zip a project

# Set variables
PROJECT_DIR="$PWD" # Current working directory
ZIP_FILE="project_$(date +'%Y%m%d_%H%M%S').zip"
NODE_MODULES="node_modules"

# Check if node_modules exists and delete it
if [ -d "$PROJECT_DIR/$NODE_MODULES" ]; then
  echo "Deleting $NODE_MODULES..."
  rm -rf "$PROJECT_DIR/$NODE_MODULES"
  if [ $? -eq 0 ]; then
    echo "$NODE_MODULES deleted successfully."
  else
    echo "Error deleting $NODE_MODULES."
    exit 1
  fi
else
  echo "$NODE_MODULES directory not found."
fi

# Zip the project
echo "Zipping the project..."
zip -r "$ZIP_FILE" "$PROJECT_DIR" -x "$PROJECT_DIR/$NODE_MODULES/*" "$PROJECT_DIR/.git/*" "$PROJECT_DIR/$ZIP_FILE"
if [ $? -eq 0 ]; then
  echo "Project zipped to $ZIP_FILE successfully."
else
  echo "Error zipping the project."
  exit 1
fi

echo "Script completed."
exit 0