#!/bin/bash

# Script to split a CSV file into chunks with headers

# Usage: ./split_csv.sh <input_csv_path> <output_folder> <chunk_size>

if [ $# -ne 3 ]; then
  echo "Usage: $0 <input_csv_path> <output_folder> <chunk_size>"
  exit 1
fi

INPUT_CSV="$1"
OUTPUT_FOLDER="$2"
CHUNK_SIZE="$3"

# Check if input file exists
if [ ! -f "$INPUT_CSV" ]; then
  echo "Error: Input CSV file '$INPUT_CSV' not found."
  exit 1
fi

# Check if output folder exists, create if not
if [ ! -d "$OUTPUT_FOLDER" ]; then
  mkdir -p "$OUTPUT_FOLDER"
  if [ $? -ne 0 ]; then
    echo "Error: Failed to create output folder '$OUTPUT_FOLDER'."
    exit 1
  fi

fi

# Get header from the input CSV
HEADER=$(head -n 1 "$INPUT_CSV")

# Calculate the number of lines excluding the header
DATA_LINES=$(wc -l < "$INPUT_CSV")
DATA_LINES=$((DATA_LINES - 1))

# Calculate the number of chunks
NUM_CHUNKS=$(( (DATA_LINES + CHUNK_SIZE - 1) / CHUNK_SIZE ))

# Split the CSV into chunks
for (( i=0; i<NUM_CHUNKS; i++ )); do
  START_LINE=$((i * CHUNK_SIZE + 2)) # +2 to skip header and start from the correct data line
  END_LINE=$((START_LINE + CHUNK_SIZE - 1))
  OUTPUT_FILE="$OUTPUT_FOLDER/chunk_$((i+1)).csv"

  # Extract the chunk and add the header
  (echo "$HEADER"; sed -n "${START_LINE},${END_LINE}p" "$INPUT_CSV") > "$OUTPUT_FILE"

  if [ $? -ne 0 ]; then
    echo "Error: Failed to create chunk file '$OUTPUT_FILE'."
    exit 1
  fi
  echo "Created $OUTPUT_FILE"

done

echo "CSV splitting completed."
exit 0