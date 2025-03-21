#!/bin/bash

# Script to list ECS processes using AWS CLI

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

# Function to list ECS processes in a cluster
list_ecs_processes() {
  local cluster_name="$1"

  echo "Listing ECS processes in cluster: $cluster_name"

  aws ecs list-tasks --cluster "$cluster_name" --query taskArns --output text | while read task_arn; do
    if [ -n "$task_arn" ]; then
      aws ecs describe-tasks --cluster "$cluster_name" --tasks "$task_arn" --query "tasks[*].{TaskArn:taskArn, TaskDefinitionArn:taskDefinitionArn, LastStatus:lastStatus, DesiredStatus:desiredStatus, ContainerDetails:containers[*].{ContainerName:name, Image:image}}" --output json
      echo "--------------------------------------------------------"
    fi
  done

  # List services.
  aws ecs list-services --cluster "$cluster_name" --query serviceArns --output text | while read service_arn; do
    if [ -n "$service_arn" ]; then
      aws ecs describe-services --cluster "$cluster_name" --services "$service_arn" --query "services[*].{ServiceName:serviceName, TaskDefinition:taskDefinition, DesiredCount:desiredCount, RunningCount:runningCount, PendingCount:pendingCount}" --output json
      echo "--------------------------------------------------------"
    fi
  done
}

# Get list of ECS clusters
clusters=$(aws ecs list-clusters --query clusterArns --output text)

if [ -z "$clusters" ]; then
  echo "No ECS clusters found."
  exit 0
fi

# Loop through each cluster and list processes
while read cluster_arn; do
  cluster_name=$(echo "$cluster_arn" | awk -F/ '{print $2}')
  list_ecs_processes "$cluster_name"
done <<< "$clusters"

echo "ECS process listing completed."
exit 0