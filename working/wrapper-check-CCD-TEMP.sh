#!/bin/bash
#
# wrapper-check-CCD-TEMP.sh
#
# 26 Nov 2023
#
# Script to access sub-directories under AstronomyData/MAO 
# that correspond to input specifying (year month date var), e.g., 2023 12 25 M Crux.
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

if [ $4 != 'AutoFlat' ]; then

    # then (e.g., 2023 12 25 M Crux)
    maoDir=`echo "$1 $2 $3 $4 $5" | sed 's/\r//g'`
    #maoDir="$1 $2 $3 $4 $5"
    MAO_YEAR="$1"
    srcDir=`echo "$4 $5-$1$2$3" | sed 's/\r//g'`

    PYTHON_BASE_DATA_DIR="E:\\Astronomy\\AstronomyData\\MAO"
    BASE_DATA_DIR="/home/PeteAndSue/AstronomyData/MAO"

    if [ ! -e "$BASE_DATA_DIR/$MAO_YEAR/$maoDir/PIData/master" ] || \
        [ ! -e "$BASE_DATA_DIR/$MAO_YEAR/$maoDir/$srcDir" ];
    then
        echo "$BASE_DATA_DIR/$MAO_YEAR/$maoDir/PIData/master"
        ls -artl "$BASE_DATA_DIR/$MAO_YEAR/$maoDir/PIData/master"
        echo "$BASE_DATA_DIR/$MAO_YEAR/$maoDir/$srcDir"
        echo "Directory does not exist, exiting"
        exit 1
    fi

    # Call check_CCD_TEMP.py
    python.exe check_CCD_TEMP.py "$PYTHON_BASE_DATA_DIR\\$MAO_YEAR\\$maoDir\\$srcDir" 20

    echo "Finished"
else
    # then (e.g., 2023 12 25 AutoFlat 20)

    maoDriveDir=`echo "$1$2$3-sky" | sed 's/\r//g'`
    maoDataDir=`echo "$1 $2 $3" | sed 's/\r//g'`

    BASE_DATA_DIR="/home/PeteAndSue/AstronomyData/MAO/00CalibrationFiles/Flats/minus $5"

    #Create directories

    if [ -e "$BASE_DATA_DIR/$maoDataDir" ];
    then
        echo "Directories exist, continuing"
    elif [ ! -e "$BASE_DATA_DIR" ];
    then
        # Create BASE_DATA_DIR
        mkdir "$BASE_DATA_DIR" 2>/dev/null 
    fi
    if [ ! -e "$BASE_DATA_DIR/$maoDataDir" ]; 
    then
        mkdir "$BASE_DATA_DIR/$maoDataDir" 2>/dev/null 
    fi

    #Copy corresponding MAO Drive folders for B and V only to the newly created directory

    MAO_AUTOFLAT="/home/PeteAndSue/MAO-AutoFlat"

    if [ -e "$MAO_AUTOFLAT/$maoDriveDir" ] && \
        [ -e "$MAO_AUTOFLAT/$maoDriveDir/Flat-sky-V" ] && \
        [ -e "$MAO_AUTOFLAT/$maoDriveDir/Flat-sky-B" ];
    then
        echo "copying $MAO_AUTOFLAT/$maoDriveDir"
        cp -r "$MAO_AUTOFLAT/$maoDriveDir/Flat-sky-V" "$BASE_DATA_DIR/$maoDataDir"
        cp -r "$MAO_AUTOFLAT/$maoDriveDir/Flat-sky-B" "$BASE_DATA_DIR/$maoDataDir"
    else
        echo "Cannot find $maoDriveDir on MAO Drive"
        exit 1
    fi

    echo "Finished $maoDir"
    exit 0

fi
