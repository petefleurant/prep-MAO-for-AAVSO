#!/bin/bash

# Base URL for the files
base_url="http://portal.nersc.gov/project/cosmo/temp/dstn/index-5200/index-5203-"

# Loop through the range 01 to 47
for i in $(seq -w 1 47)
do
    # Construct the full URL
    url="${base_url}${i}.fits"

    # Download the file
    wget "$url"
done

# Base URL for the files
base_url="http://portal.nersc.gov/project/cosmo/temp/dstn/index-5200/index-5204-"

# Loop through the range 01 to 47
for i in $(seq -w 0 47)
do
    # Construct the full URL
    url="${base_url}${i}.fits"

    # Download the file
    wget "$url"
done

# Base URL for the files
base_url="http://portal.nersc.gov/project/cosmo/temp/dstn/index-5200/index-5205-"

# Loop through the range 01 to 47
for i in $(seq -w 0 47)
do
    # Construct the full URL
    url="${base_url}${i}.fits"

    # Download the file
    wget "$url"
done

# Base URL for the files
base_url="http://portal.nersc.gov/project/cosmo/temp/dstn/index-5200/index-5206-"

# Loop through the range 01 to 47
for i in $(seq -w 0 47)
do
    # Construct the full URL
    url="${base_url}${i}.fits"

    # Download the file
    wget "$url"
done

echo "Download complete."
