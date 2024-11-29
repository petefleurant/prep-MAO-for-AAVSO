#!/bin/bash
#
# wrapper-filename-rename.sh
#
# 20 Nov 2023
#
# Script to read list of MAO directories and rename files in PIData/AAVSO folder 
# by appending date to filename. 
# (e.g., PIData/AAVSO/M Crux 10.00s_FILTER-B_mono_FILTER-B.fit 
#  ----> PIData/AAVSO/M Crux 10.00s_FILTER-B_mono_FILTER-B_20231225.fit  )
#

# Verify that maoDir is in correct format (e.g., 2023 12 25 M Crux)
if [ $# -eq 0 ] || [ $# -eq 1 ]; then
    echo \
    "Enter MAO sub-directory for parameters, e.g., 2023 12 25 M Crux \
Script that wraps calc-AIRMASS.py. \
Input specifying (year month date var), e.g., 2023 12 25 M Crux."
    echo ""
    exit
elif [ $# -ne 5 ]; then
    echo "Incorrect MAO sub-directory format (e.g., 2023 12 25 M Crux)"
    exit
fi

maoDir=`echo "$1 $2 $3 $4 $5" | sed 's/\r//g'`
#maoDir="$1 $2 $3 $4 $5"
MAO_YEAR="$1"
srcDir=`echo "$4 $5-$1$2$3" | sed 's/\r//g'`

BASE_DATA_DIR="$HOME/AstronomyData/MAO"

if [ ! -e "$BASE_DATA_DIR/$MAO_YEAR/$maoDir/PIData/master/AAVSO" ];
then
    echo "$BASE_DATA_DIR/$MAO_YEAR/$maoDir/PIData/master"
    ls -artl "$BASE_DATA_DIR/$MAO_YEAR/$maoDir/PIData/master"
    echo "Directory does not exist, exiting"
    exit 1
fi

cd "$BASE_DATA_DIR/$MAO_YEAR/$maoDir/PIData/master/AAVSO" || exit 1

# Iterate over all files in the directory
for file in *; do
    # Check if the file is a regular file
    if [ -f "$file" ]; then
        # Get the file extension (if any)
        extension="${file##*.}"

        # Get the filename without extension
        filename="${file%.*}"

        # Append the string to the filename
        new_filename="${filename}_$1$2$3"

        # If there was an extension, append it back to the new filename
        if [ -n "$extension" ]; then
            new_filename="$new_filename.$extension"
        fi

        # Rename the file
        mv "$file" "$new_filename"

        echo "Appended '$1$2$3' to '$file' and renamed to '$new_filename'"
    fi
done

echo "Finished"
