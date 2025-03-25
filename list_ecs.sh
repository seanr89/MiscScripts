#!/bin/bash

# Script to list ECS processes using AWS CLI

# Usage: ./list_ecs.sh <input_region> <output_file>
# Example: ./list_ecs.sh us-east-1 output.json

if [ $# -ne 2 ]; then
  echo "Usage: $0 <input_region> <output_file>"
  exit 1
fi

INPUT_REGION="$1"
OUTPUT_FILE="$2"

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
  local task_count=0
  local definitions="[" # Start JSON array

  # Get list of ECS task definitions
  aws ecs list-task-definitions --region $INPUT_REGION --query taskDefinitionArns | while read task_arn; do
    # Remove the trailing comma from task_arn
    task_arn=${task_arn%,}

    # Skip if task_arn is empty or contains [ or ]
    if [[ -n "$task_arn" && "$task_arn" != *'['* && "$task_arn" != *']'* ]]; then
      definition=$(aws ecs describe-task-definition --region $INPUT_REGION --task-definition $task_arn --query "taskDefinition.{Family:family, Revision:revision, ContainerDefinitions:containerDefinitions[*].{Name:name, Image:image}}" --output json)
      # Add comma before subsequent entries
      if ((task_count > 0)); then
        definitions+=","
      fi
      definitions+="$definition" # Append definition to JSON array
      ((task_count++))
    fi
  done
  definitions+="]" # End JSON array
  echo "Found $task_count task definitions."

  # Write JSON to file
  echo "$definitions" > "$OUTPUT_FILE"
  echo "Task definitions written to $OUTPUT_FILE"
}

# Function to list ECS tasks within a cluster
list_ecs_tasks() {
  local cluster_arn="$1"
  local cluster_name=$(echo "$cluster_arn" | awk -F/ '{print $2}') # Extract cluster name
  echo "Cluster: $cluster_name"
  local tasks_output="["
  local task_count=0

  # Get list of tasks in the cluster
  local task_arns=$(aws ecs list-tasks --cluster "$cluster_arn" --region "$INPUT_REGION" --query taskArns --output text)

  if [ -n "$task_arns" ]; then
    # Describe the tasks to get more details
    local tasks=$(aws ecs describe-tasks --cluster "$cluster_arn" --tasks "$task_arns" --region "$INPUT_REGION" --output json)
     # Add comma before subsequent entries

    for task in $tasks;
    do
      if ((task_count > 0)); then
        tasks_output+=","
      fi
      tasks_output+="$task"
      ((task_count++))
    done
    tasks_output+="]"
    echo "$tasks_output" > "$OUTPUT_FILE"
    echo "tasks written to $OUTPUT_FILE"
  else
    echo "  No tasks found in cluster $cluster_name"
  fi
}

# Get list of ECS clusters
cluster_arns=$(aws ecs list-clusters --region $INPUT_REGION --query clusterArns --output text)

if [ -z "$cluster_arns" ]; then
  echo "No ECS clusters found."
  exit 0
fi

# Filter clusters to only include those containing "fargate"
fargate_clusters=$(echo "$cluster_arns" | grep "fargate")

# Loop through each Fargate cluster and list tasks
while read cluster_arn; do
  list_ecs_tasks "$cluster_arn"
done <<< "$fargate_clusters"

list_ecs_task_definitions

echo "ECS process listing completed."
exit 0
