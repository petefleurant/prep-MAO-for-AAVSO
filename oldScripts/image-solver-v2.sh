!/bin/bash
#
# image-solver.sh
#
# 27 Aug 2023
#
# Script to replace the now "gone" image-solver usage in PixInsight (1.8.9-2).
# PixInsight no longer supports WCS data in FIT files. You used to be able to save an xisf file
# containing WCS data as a FIT file, now that data is gone in the FIT file. 
#
# From the release announcement
#  Our astrometric solutions are now based exclusively on XISF properties
#  and can only be stored in XISF files. We no longer depend on FITS header
#  keywords and don't generate any WCS FITS keywords. We still use standard
#  WCS projections (such as the Gnomonic projection), but the independence
#  of FITS metadata allows us to ensure the internal coherence of our solutions
#  at all stages, especially in terms of geometric properties and coordinate systems,
#  which are incompatible with FITS conventions.
#
#
echo \
"Invokes Astrometry.net's solve-field \
to insert WCS data into fit file in given dir."
echo ""
read -p "Enter MAO directory (e.g., 2023 08 22 Y And):" maoDir
# Verify that maoDir is in correct format (e.g., 2023 12 25 M Crux)
IFS=' '
read -a strarr <<< "$maoDir"
if [ ${#strarr[*]} -ne 5 ]; then
    echo "Incorrect MAO sub-directory format (e.g., 2023 12 25 M Crux)"
    exit
fi

BASE_DIR="/home/PeteAndSue/AstronomyData/MAO/${strarr[0]}"
MASTER_DIR=$BASE_DIR"/"$maoDir"/PIData/master"
echo "master directory is $MASTER_DIR"
if [ -e "$MASTER_DIR" ]
then
    echo "running"
else
    echo "master dir does not exist; process fit file(s) first"
    exit
fi
   
cd "$MASTER_DIR"
RESULT_DIR=AAVSO
mkdir "$RESULT_DIR"
SOLVED_DIR=$MASTER_DIR"/$RESULT_DIR"
echo "Results will be in $SOLVED_DIR"
#lists fit files
/usr/bin/ls *.fit

solve-field \
--no-remove-lines \
--overwrite \
--no-plots \
--dir "$SOLVED_DIR" \
--uniformize 0 \
--fits-image \
--corr "none" \
--index-xyls "none" \
--scale-low 1 \
--scale-high 2 \
*.fit

# These switches place a un-needed file in master
#--axy "none" \
#--pnm "none" \


cd "$SOLVED_DIR"

for newFile in *.new
do
  # mv .new to .fit
  theFilename=`echo "$newFile" | sed 's/.\{4\}$//'`
  echo "moving $theFilename.new to $theFilename.fits"
  mv -f "$theFilename".new "$theFilename".fit
done

#cleanup
rm -f *.match *.wcs *.solved *.rdls *.axy

echo "Finished"
