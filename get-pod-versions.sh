#!/bin/bash

# Check if namespace is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <namespace> [json|txt]"
  exit 1
fi

NAMESPACE="$1"
OUTPUT_FORMAT="${2:-txt}" # Default to txt if no format is provided

# Get the pods in the specified namespace
pods=$(kubectl get pods -n "$NAMESPACE" -o jsonpath='{.items[*].metadata.name}')

# Function to generate JSON output
generate_json() {
  local json_output="["
  local first_pod=true

  for pod in $pods; do
    if ! $first_pod; then
      json_output+=","
    fi
    first_pod=false
    json_output+="{ \"pod\": \"$pod\", \"containers\": ["
    local containers=$(kubectl get pod "$pod" -n "$NAMESPACE" -o jsonpath='{.spec.containers[*].image}')
    local first_container=true
    if [ -n "$containers" ]; then
      for container in $containers; do
        if ! $first_container; then
          json_output+=","
        fi
        first_container=false
        json_output+="\"$container\""
      done
    fi
    json_output+="]}"
  done

  json_output+="]"
  echo "$json_output"
}

# Function to generate TXT output
generate_txt() {
  if [ -n "$pods" ]; then
    for pod in $pods; do
      echo "Pod: $pod"
      containers=$(kubectl get pod "$pod" -n "$NAMESPACE" -o jsonpath='{.spec.containers[*].image}')
      if [ -n "$containers" ]; then
        for container in $containers; do
          echo "  Container: $container"
        done
      else
        echo "  No containers found in pod."
      fi
    done
  else
    echo "No pods found in namespace: $NAMESPACE"
  fi
}

# Generate output based on the specified format
if [ "$OUTPUT_FORMAT" == "json" ]; then
  generate_json > "${NAMESPACE}_pod_versions.json"
  echo "Output saved to ${NAMESPACE}_pod_versions.json"
elif [ "$OUTPUT_FORMAT" == "txt" ]; then
  generate_txt > "${NAMESPACE}_pod_versions.txt"
  echo "Output saved to ${NAMESPACE}_pod_versions.txt"
else
  echo "Invalid output format. Use 'json' or 'txt'."
  exit 1
fi