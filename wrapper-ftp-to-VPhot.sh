#!/bin/bash
#
# wrapper-calc-AIRMASS.sh
#
# 28 Nov 2023
#
# Script to access sub-directories under AstronomyData/MAO 
# that correspond to input specifying (year month date var), e.g., 2023 12 25 M Crux.
#
#

# Verify that maoDir is in correct format (e.g., 2023 12 25 M Crux)
if [ $# -eq 0 ] || [ $# -eq 1 ]; then
    echo \
    "Enter MAO sub-directory for parameters, e.g., 2023 12 25 M Crux \
Script that wraps ftp-to-VPhot.py. \
Input specifying (year month date var), e.g., 2023 12 25 M Crux."
    echo ""
    exit
elif [ $# -ne 5 ]; then
    echo "Incorrect MAO sub-directory format (e.g., 2023 12 25 M Crux)"
    exit
fi

maoDir=`echo "$1 $2 $3 $4 $5" | sed 's/\r//g'`
MAO_YEAR="$1"

PYTHON_BASE_DATA_DIR="E:\\Astronomy\\AstronomyData\\MAO"
BASE_DATA_DIR="$HOME/AstronomyData/MAO"

if [ ! -e "$BASE_DATA_DIR/$MAO_YEAR/$maoDir/PIData/master/AAVSO" ];
then
    echo "$BASE_DATA_DIR/$MAO_YEAR/$maoDir/PIData/master"
    ls -artl "$BASE_DATA_DIR/$MAO_YEAR/$maoDir/PIData/master"
    echo "Directory does not exist, exiting"
    exit 1
fi

# Call ftp-to-VPhot.py
which python
python ftp-to-VPhot.py "$PYTHON_BASE_DATA_DIR\\$MAO_YEAR\\$maoDir\\PIData\\master\\AAVSO"

echo "Finished"
