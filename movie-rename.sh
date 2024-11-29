#!/bin/bash
#
# movie-rename.sh
#
# 24 Oct 2023
#
#
# Directory where your files are located
directory="/home/PeteAndSue/Iceland/Movies"

# Loop through all files with the *.jpg extension in the directory
for file in "$directory"/*.jpg; do
  if [ -e "$file" ]; then
    # Get the current file name
    filename=$(basename "$file")

    # Substitute the first 10 characters with "sample"
    new_filename="Aurora${filename:12}"

    # Construct the new path
    new_path="$directory/$new_filename"

    # Rename the file
    mv "$file" "$new_path"
    echo "Renamed $filename to $new_filename"
  fi
done
