#!/bin/bash
#
# prep-for-MAO-proc.sh
#
# 28 Aug 2023
#
# Script to create sub-directories under AstronomyData/MAO and under AAVSO Reports/MAO
# that correspond to input specifying (year month date var), e.g., 2023 12 25 M Crux.
#
# If both sub-directories exist, then script states that they already exist, does nothing else,
# then exits.
#
echo \
" Script to create sub-directories under AstronomyData/MAO and under AAVSO Reports/MAO\
  that correspond to input specifying (year month date var), e.g., 2023 12 25 M Crux.\
  If both sub-directories exist, then script states that they already exist, does nothing else,\
  then exits."
echo ""

read -p "Enter MAO directory (e.g., 2023 08 22 Y And):" maoDir

# Verify that maoDir is in correct format (e.g., 2023 12 25 M Crux)
IFS=' '
read -a strarr <<< "$maoDir"
if [ ${#strarr[*]} -eq 0 ]; then
    break
elif [ ${#strarr[*]} -ne 5 ]; then
    echo "Incorrect MAO sub-directory format (e.g., 2023 12 25 M Crux)"
    continue
fi
echo "you entered: " "$maoDir"

BASE_DATA_DIR="/home/PeteAndSue/AstronomyData/MAO"
BASE_AAVSO_DIR="/home/PeteAndSue/AAVSO Reports/MAO"

if [ -e "$BASE_DATA_DIR/${strarr[0]}/$maoDir/PIData" -a -e "$BASE_AAVSO_DIR/${strarr[0]}/$maoDir" ];
then
    echo "Directories exist, exiting"
    exit 0
elif [ ! -e "$BASE_DATA_DIR/${strarr[0]}/$maoDir/PIData" ];
    then
        # Create BASE_DATA_DIR and its PIData
        mkdir "$BASE_DATA_DIR/${strarr[0]}" 2>/dev/null 
        mkdir "$BASE_DATA_DIR/${strarr[0]}/$maoDir" 
        mkdir "$BASE_DATA_DIR/${strarr[0]}/$maoDir/PIData" 
    fi
if [ ! -e "$BASE_AAVSO_DIR/${strarr[0]}/$maoDir" ]; 
    then
        mkdir "$BASE_AAVSO_DIR/${strarr[0]}" 2>/dev/null 
        mkdir "$BASE_AAVSO_DIR/${strarr[0]}/$maoDir" 
fi

echo "Finished"
