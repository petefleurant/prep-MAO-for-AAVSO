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

# Verify that maoDir is in correct format (e.g., 2023 12 25 M Crux)
if [ $# -eq 0 ] || [ $# -eq 1 ]; then
    echo \
    "Enter MAO sub-directory for parameters, e.g., 2023 12 25 M Crux
Script to create sub-directories under AstronomyData/MAO and under AAVSO Reports/MAO\
that correspond to input specifying (year month date var), e.g., 2023 12 25 M Crux.\
If both sub-directories exist, then script states that they already exist, does nothing else,\
then exits."
    echo ""
    exit
elif [ $# -ne 5 ]; then
    echo "Incorrect MAO sub-directory format (e.g., 2023 12 25 M Crux)"
    exit
fi

maoDir=`echo "$1 $2 $3 $4 $5" | sed 's/\r//g'`
#maoDir="$1 $2 $3 $4 $5"
MAO_YEAR="$1"

BASE_DATA_DIR="$HOME/AstronomyData/MAO"
BASE_AAVSO_DIR="$HOME/AAVSO Reports/MAO"

if [ -e "$BASE_DATA_DIR/$MAO_YEAR/$maoDir/PIData" -a -e "$BASE_AAVSO_DIR/$MAO_YEAR/$maoDir" ];
then
    echo "Directories exist, exiting"
    exit 0
elif [ ! -e "$BASE_DATA_DIR/$MAO_YEAR/$maoDir/PIData" ];
    then
        # Create BASE_DATA_DIR and its PIData
        mkdir "$BASE_DATA_DIR/$MAO_YEAR" 2>/dev/null 
        mkdir "$BASE_DATA_DIR/$MAO_YEAR/$maoDir" 
        mkdir "$BASE_DATA_DIR/$MAO_YEAR/$maoDir/PIData" 
    fi
if [ ! -e "$BASE_AAVSO_DIR/$MAO_YEAR/$maoDir" ]; 
    then
        mkdir "$BASE_AAVSO_DIR/$MAO_YEAR" 2>/dev/null 
        mkdir "$BASE_AAVSO_DIR/$MAO_YEAR/$maoDir" 
fi

echo "Finished $maoDir"
