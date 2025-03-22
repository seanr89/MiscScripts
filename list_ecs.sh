#!/bin/bash

# Script to list ECS processes using AWS CLI

# Usage: ./list_ecs.sh <input_region>

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

list_ecs_task_definitions() {
  echo "Listing ECS task definitions..."

  # Get list of ECS task definitions
  aws ecs list-task-definitions --region $INPUT_REGION --query taskDefinitionArns --output text | while read task_arn; do
    if [ -n "$task_arn" ]; then
      aws ecs describe-task-definition --region $INPUT_REGION --task-definition "$task_arn" --query "taskDefinition.{Family:family, Revision:revision, ContainerDefinitions:containerDefinitions[*].{Name:name, Image:image}}" --output json
      echo "--------------------------------------------------------"
    fi
  done
}

# Function to list ECS processes in a cluster
list_ecs_processes() {
  local cluster_name="$1"

  echo "Listing ECS processes in cluster: $cluster_name"

  aws ecs list-task-definitions --query 'taskDefinitionArns[*]' --output text | \
  while read arn; do
    aws ecs describe-task-definition --task-definition "$arn" --query "containerDefinitions[*].image" --output text;
  done

  # aws ecs list-tasks --region $INPUT_REGION --cluster "$cluster_name" --query taskArns --output text | while read task_arn; do
  #   if [ -n "$task_arn" ]; then
  #     aws ecs describe-tasks --cluster "$cluster_name" --tasks "$task_arn" --query "tasks[*].{TaskArn:taskArn, TaskDefinitionArn:taskDefinitionArn, LastStatus:lastStatus, DesiredStatus:desiredStatus, ContainerDetails:containers[*].{ContainerName:name, Image:image}}" --output json
  #     echo "--------------------------------------------------------"
  #   fi
  # done

  # List services.
  # aws ecs list-services --region $INPUT_REGION --cluster "$cluster_name" --query serviceArns --output text | while read service_arn; do
  #   if [ -n "$service_arn" ]; then
  #     aws ecs describe-services --cluster "$cluster_name" --services "$service_arn" --query "services[*].{ServiceName:serviceName, TaskDefinition:taskDefinition, DesiredCount:desiredCount, RunningCount:runningCount, PendingCount:pendingCount}" --output json
  #     echo "--------------------------------------------------------"
  #   fi
  # done
}

# Get list of ECS clusters
clusters=$(aws ecs list-clusters --region $INPUT_REGION --query clusterArns --output text)

if [ -z "$clusters" ]; then
  echo "No ECS clusters found."
  exit 0
fi

# Filter clusters to only include those containing "fargate"
fargate_clusters=$(echo "$clusters" | grep "fargate")

# Loop through each cluster and list processes
while read cluster_arn; do
  cluster_name=$(echo "$cluster_arn" | awk -F/ '{print $2}')
  echo "Cluster: $cluster_name"
  ##list_ecs_processes "$cluster_name"
done <<< "$faragte_clusters"

list_ecs_task_definitions

echo "ECS process listing completed."
exit 0