#!/bin/bash
#
# cp-Fits-for-VPhot.sh
#
# 28 Nov 2023
# 23 Nov 2023
#
# Script to cp $BASE_DIR/PIData/master/AAVSO/*.fit files to //vphot. 
# $BASE_DIR is corresponds to input specifying (year month date var), e.g., 2023 12 25 M Crux.
#
# The destination directory is the ftp server vphot.aavso.org (~/vphot is soft link)
#
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
VAR_DATE=`echo "$1 $2 $3" | sed 's/\r//g'`
MAO_YEAR="$1"

BASE_DATA_DIR="/home/PeteAndSue/AstronomyData/MAO"
VPHOT_DIR="/home/PeteAndSue/vphot"

if [ ! -e "$BASE_DATA_DIR/$MAO_YEAR/$maoDir/PIData/master/AAVSO" ] ;
then
    echo "master/AAVSO Directory does not exist, exiting"
    exit 1
else
    cp -v "$BASE_DATA_DIR/$MAO_YEAR/$maoDir/PIData/master/AAVSO/"*.fit  "$VPHOT_DIR"
fi

echo "Finished $maoDir"
