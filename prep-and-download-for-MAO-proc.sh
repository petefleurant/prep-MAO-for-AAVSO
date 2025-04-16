#!/bin/bash
#
# prep-and-download-for-MAO-proc.sh
#
#
# 26 Nov 2023
# 12 Nov 2023 
# 28 Aug 2023 (prep-for-MAO-proc.sh)
#
# Script to create sub-directories under AstronomyData/MAO and under AAVSO Reports/MAO
# that correspond to input specifying (year month date var), e.g., 2023 12 25 M Crux.
#
# If both sub-directories exist, then script states that they already exist
# 
# Then (instead of downloading from MAO Drive in browser) access Google Drive (H) 
# and get corresponding images from H:\ drive and copy to AstronomyData/MAO
#
# If input is in form "<year> <month> <date> AutoFlat <temperature>" then B and V flats are retrieve
# from $MAO_AUTOFLAT
#

# Verify that maoDir is in correct format (e.g., 2023 12 25 M Crux)
if [ $# -eq 0 ] || [ $# -eq 1 ]; then
    echo \
    "Enter MAO sub-directory for parameters, e.g., 2023 12 25 M Crux
Script to create sub-directories under AstronomyData/MAO and under AAVSO Reports/MAO\
that correspond to input specifying (year month date var), e.g., 2023 12 25 M Crux.\
If both sub-directories exist, then script states that they already exist, then exits."
    echo ""
    exit
elif [ $# -ne 5 ]; then
    echo "Incorrect MAO sub-directory format (e.g., 2023 12 25 M Crux)"
    exit
fi

if [ $4 != 'AutoFlat' ]; then
    # then (e.g., 2023 12 25 M Crux)
    maoDir=`echo "$1 $2 $3 $4 $5" | sed 's/\r//g'`
    varName=`echo "$4 $5" | sed 's/\r//g'`
    maoDate=`echo "$1$2$3" | sed 's/\r//g'`

    MAO_YEAR="$1"

    BASE_DATA_DIR="$HOME/AstronomyData/MAO"
    BASE_AAVSO_DIR="$HOME/AAVSO Reports/MAO"

    #Create directories

    if [ -e "$BASE_DATA_DIR/$MAO_YEAR/$maoDir/PIData" -a -e "$BASE_AAVSO_DIR/$MAO_YEAR/$maoDir" ];
    then
        echo "Directories exist, continuing"
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

    #Copy corresponding MAO Drive folder to the newly created directory
    #(Before this, we downloaded manually from browser and unzipped file)

    #The source is either in the ~/MAO-Pete or ~/MAO-Pierre directory. 
    # (Why 2 different choices? "Don't ask!")
    # Example: Given parameters  "2023 12 25 M Crux", the source folder is
    # ~/MAO-Pierre/M Crux/M Crux-20231225/ 
    # or
    # ~/MAO-Pete/M Crux/M Crux-20231225/ 
    # Finding the folder then, it is copied to "~/AstronomyData/MAO/2023/2023 12 25 M Crux/"
    #
    #

    MAO_PETE="$HOME/MAO-Pete"
    MAO_PIERRE="$HOME/MAO-Pierre"

    if [ -e "$MAO_PIERRE/$varName" ];
    then
        echo "copying $MAO_PIERRE/$varName/$varName-$maoDate"
        cp -r "$MAO_PIERRE/$varName/$varName-$maoDate" "$BASE_DATA_DIR/$MAO_YEAR/$maoDir"

    elif [ -e "$MAO_PETE/$varName" ];
    then
        echo "copying $MAO_PETE/$varName/$varName-$maoDate"
        cp -r "$MAO_PETE/$varName/$varName-$maoDate" "$BASE_DATA_DIR/$MAO_YEAR/$maoDir"
    else
        echo "Cannot find $varName on MAO Drive; MAO_Pete=$MAO_Pete; MAO_PIERRE=$MAO_PIERRE" 
        exit 1
    fi

    echo "Finished $maoDir"
    exit 0

else
    # then (e.g., 2023 12 25 AutoFlat 20)

    maoDriveDir=`echo "$1$2$3-sky" | sed 's/\r//g'`
    maoDataDir=`echo "$1 $2 $3" | sed 's/\r//g'`
    celsius_temp=`echo "$5" | sed 's/\r//g'`

    BASE_DATA_DIR="$HOME/AstronomyData/MAO/00CalibrationFiles/Flats/minus $celsius_temp"

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

    #Copy corresponding MAO Drive folders for V, B, I and V to the newly created directory

    MAO_AUTOFLAT="$HOME/MAO-AutoFlat"

    if [ -e "$MAO_AUTOFLAT/$maoDriveDir" ] && \
        [ -e "$MAO_AUTOFLAT/$maoDriveDir/Flat-sky-V" ] && \
        [ -e "$MAO_AUTOFLAT/$maoDriveDir/Flat-sky-B" ] && \
        [ -e "$MAO_AUTOFLAT/$maoDriveDir/Flat-sky-I" ] && \
        [ -e "$MAO_AUTOFLAT/$maoDriveDir/Flat-sky-R" ];
    then
        echo "copying $MAO_AUTOFLAT/$maoDriveDir"
        cp -r "$MAO_AUTOFLAT/$maoDriveDir/Flat-sky-V" "$BASE_DATA_DIR/$maoDataDir"
        cp -r "$MAO_AUTOFLAT/$maoDriveDir/Flat-sky-B" "$BASE_DATA_DIR/$maoDataDir"
        cp -r "$MAO_AUTOFLAT/$maoDriveDir/Flat-sky-I" "$BASE_DATA_DIR/$maoDataDir"
        cp -r "$MAO_AUTOFLAT/$maoDriveDir/Flat-sky-R" "$BASE_DATA_DIR/$maoDataDir"
    else
        echo "Cannot find $maoDriveDir on MAO Drive"
        exit 1
    fi

    echo "Finished $maoDir"
    exit 0

fi

