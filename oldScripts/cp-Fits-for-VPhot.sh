#!/bin/bash
#
# cp-Fits-for-VPhot.sh
#
# 23 Nov 2023
#
# Script to cp $BASE_DIR/PIData/master/AAVSO/*.fit files to a common temp directory. 
# $BASE_DIR is corresponds to input specifying (year month date var), e.g., 2023 12 25 M Crux.
#
# The destination directory is $BASE_DATA_DIR/AAVSO/temp/$VAR_DATE
#
#

# Verify that maoDir is in correct format (e.g., 2023 12 25 M Crux)
if [ $# -eq 0 ] || [ $# -eq 1 ]; then
    echo \
    "Enter MAO sub-directory for parameters, e.g., 2023 12 25 M Crux \
Input specifies (year month date var), e.g., 2023 12 25 M Crux."
    echo ""
    exit
elif [ $# -ne 5 ]; then
    echo "Incorrect MAO sub-directory format (e.g., 2023 12 25 M Crux)"
    exit
fi

maoDir=`echo "$1 $2 $3 $4 $5" | sed 's/\r//g'`
VAR_DATE=`echo "$1 $2 $3" | sed 's/\r//g'`
MAO_YEAR="$1"

BASE_DATA_DIR="/home/PeteAndSue/AstronomyData/MAO"

if [ ! -e "$BASE_DATA_DIR/$MAO_YEAR/$maoDir/PIData/master/AAVSO" ] || \
   [ ! -e "$BASE_DATA_DIR/AAVSO" ] ;
then
    echo "AAVSO Directory does not exist, exiting"
    exit 1
else
    mkdir -v "$BASE_DATA_DIR/AAVSO/temp"
    mkdir -v "$BASE_DATA_DIR/AAVSO/temp/$VAR_DATE"
    cp -vu "$BASE_DATA_DIR/$MAO_YEAR/$maoDir/PIData/master/AAVSO/"*.fit  "$BASE_DATA_DIR/AAVSO/temp/$VAR_DATE"
fi

echo "Finished $maoDir"
