#!/bin/bash
#
# chk-CCD-TEMP.sh
#
#
# 23 Feb 2024 
# - added check for non-sky flats or panel flats e.g., Flat-Ha
# 29 Nov 2023 original
# 
#
# Script to access sub-directories under AstronomyData/MAO 
# that correspond to input specifying (year month date var), e.g., 2023 12 25 M Crux.
# or
# AutoFlat 
#

# Verify that maoDir is in correct format (e.g., 2023 12 25 M Crux , or 2023 12 25 AutoFlat 20)
if [ $# -eq 0 ] || [ $# -eq 1 ]; then
    echo \
    "Enter MAO sub-directory for parameters, e.g., 2023 12 25 M Crux \
Script that wraps chk-CCD-TEMP.py. \
Input specifying (year month date var), e.g., 2023 12 25 M Crux."
    echo ""
    exit
elif [ $# -ne 5 ] ; then
    echo "Incorrect MAO sub-directory format (e.g., 2023 12 25 M Crux, or 2023 12 25 AutoFlat 20)"
    exit
fi


if [ $4 != 'AutoFlat' ]; then

    maoDir=`echo "$1 $2 $3 $4 $5" | sed 's/\r//g'`
    #maoDir="$1 $2 $3 $4 $5"
    MAO_YEAR="$1"
    srcDir=`echo "$4 $5-$1$2$3" | sed 's/\r//g'`

    PYTHON_BASE_DATA_DIR="E:\\Astronomy\\AstronomyData\\MAO"
    BASE_DATA_DIR="$HOME/AstronomyData/MAO"

    if [ ! -e "$BASE_DATA_DIR/$MAO_YEAR/$maoDir/$srcDir" ];
    then
        echo "$BASE_DATA_DIR/$MAO_YEAR/$maoDir/$srcDir"
        echo "Directory does not exist, exiting"
        exit 1
    fi

    # Call chk-CCD-TEMP.py
    which python
    python chk-CCD-TEMP.py "$PYTHON_BASE_DATA_DIR\\$MAO_YEAR\\$maoDir\\$srcDir" 

    echo "Finished"
else
    # then this is an AutoFlat (e.g., 2023 12 25 AutoFlat 20)
    # check for sky, panel, and Ha panel
    found_flats=false

    maoDriveDir=`echo "$1$2$3-sky" | sed 's/\r//g'`
    maoDataDir=`echo "$1 $2 $3" | sed 's/\r//g'`
    celsius_temp=`echo "$5" | sed 's/\r//g'`

    BASE_DATA_DIR="$HOME/AstronomyData/MAO/00CalibrationFiles/Flats/minus $celsius_temp"
    PYTHON_BASE_DATA_DIR="E:\\Astronomy\\AstronomyData\\MAO\\00CalibrationFiles\\Flats\\minus $celsius_temp"

    # check for sky flats 
    if [ -e "$BASE_DATA_DIR/$maoDataDir/Flat-sky-B" ] || \
       [ -e "$BASE_DATA_DIR/$maoDataDir/Flat-sky-V" ] || \
       [ -e "$BASE_DATA_DIR/$maoDataDir/Flat-sky-I" ] || \
       [ -e "$BASE_DATA_DIR/$maoDataDir/Flat-sky-R" ] ; 
    then
        found_flats=true
        echo "checking CCD-TEMP for 'sky' $BASE_DATA_DIR/$MAO_YEAR/$maoDataDir/Flat-sky-[BVIR]"

        # Call chk-CCD-TEMP.py for B 
        which python
        python chk-CCD-TEMP.py "$PYTHON_BASE_DATA_DIR\\$maoDataDir\\Flat-sky-B" 

        # Call chk-CCD-TEMP.py for V
        which python
        python chk-CCD-TEMP.py "$PYTHON_BASE_DATA_DIR\\$maoDataDir\\Flat-sky-V"

        # Call chk-CCD-TEMP.py for I
        which python
        python chk-CCD-TEMP.py "$PYTHON_BASE_DATA_DIR\\$maoDataDir\\Flat-sky-I"

        # Call chk-CCD-TEMP.py for R
        which python
        python chk-CCD-TEMP.py "$PYTHON_BASE_DATA_DIR\\$maoDataDir\\Flat-sky-R"
        echo "Completed Checking Sky-Flats CCD-TEMP"

    # check for panel flats 
    fi
    # check for panel flats 
    if [ -e "$BASE_DATA_DIR/$maoDataDir/Flat-B" ] && \
       [ -e "$BASE_DATA_DIR/$maoDataDir/Flat-V" ] ; 
    then
        found_flats=true

        echo "checking CCD-TEMP for 'panel' $BASE_DATA_DIR/$MAO_YEAR/$maoDataDir/Flat-[BV]"

        # Call chk-CCD-TEMP.py for B 
        which python
        python chk-CCD-TEMP.py "$PYTHON_BASE_DATA_DIR\\$maoDataDir\\Flat-B" 

        # Call chk-CCD-TEMP.py for V
        which python
        python chk-CCD-TEMP.py "$PYTHON_BASE_DATA_DIR\\$maoDataDir\\Flat-V"
    fi
    # check for Ha panel flats 
    if [ -e "$BASE_DATA_DIR/$maoDataDir/Flat-Ha" ] ;
    then
        found_flats=true
        echo "checking CCD-TEMP for 'panel' $BASE_DATA_DIR/$MAO_YEAR/$maoDataDir/Flat-Ha"

        # Call chk-CCD-TEMP.py for Ha
        which python
        python chk-CCD-TEMP.py "$PYTHON_BASE_DATA_DIR\\$maoDataDir\\Flat-Ha" 

    fi

    if [ "$found_flats" = false ] ;
    then
        echo "WARNING: no auto flats found!!! in $BASE_DATA_DIR/$maoDataDir"        
        exit 1
    fi
fi

exit
