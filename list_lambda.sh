#!/bin/bash

# Script to list AWS Lambda functions using AWS CLI

# Usage: ./list_lambda.sh <input_region>

if [ $# -ne 1 ]; then
  echo "Usage: $0 <input_region>"
  exit 1
fi

INPUT_REGION="$1"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
  echo "Error: AWS CLI is not installed. Please install it and configure your credentials."
  exit 1
fi

# Check if AWS credentials are configured
if [ -z "$(aws sts get-caller-identity --output text --query 'Arn')" ]; then
  echo "Error: AWS credentials are not configured. Please configure them using 'aws configure'."
  exit 1
fi

# Function to list Lambda functions
list_lambda_functions() {
  echo "Listing AWS Lambda functions..."

  # Get list of Lambda functions
  aws lambda list-functions --region $INPUT_REGION --query "Functions[*].{FunctionName:FunctionName, Runtime:Runtime, Handler:Handler, LastModified:LastModified, FunctionArn:FunctionArn, Tags:Tags}" --output table

  if [ $? -ne 0 ]; then
    echo "Error: Failed to list Lambda functions."
    exit 1
  fi
}

# Run the function to list Lambda functions.
list_lambda_functions

echo "Lambda function listing completed."
exit 0