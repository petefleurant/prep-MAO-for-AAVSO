#!/bin/bash

# Define the destination directory
DEST_DIR="./ASC"

# Check if the destination directory exists, create it if it doesn't
if [ ! -d "$DEST_DIR" ]; then
  echo "Destination directory does not exist. Creating..."
  mkdir -p "$DEST_DIR"
fi

# Get the list of directories matching the pattern "MAO"
# Use find to handle directory names with spaces correctly
DIR_LIST=$(find . -maxdepth 1 -type d -name "* ASC *")

# Check if any directories were found
if [ -z "$DIR_LIST" ]; then
  echo "No directories found matching the pattern."
  exit 0
fi

# Iterate over each directory in the list
while IFS= read -r dir; do
  # Skip the current directory (.)
  if [ "$dir" != "." ]; then
    echo "Moving directory: $dir"
    mv "$dir" "$DEST_DIR"
  fi
done <<< "$DIR_LIST"

echo "Move completed."
