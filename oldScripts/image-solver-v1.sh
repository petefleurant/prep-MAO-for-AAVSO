!/bin/bash
echo \
"This script invokes Astrometry.net's solve-field \
to insert WCS data into fit file in given dir."
echo ""
read -p "Enter MAO sub-directory (e.g., 2023 08 22 Y And):" maoSubdir
BASE_DIR="/home/PeteAndSue/AstronomyData/MAO/2023"
WORKING_DIR=$BASE_DIR"/"$maoSubdir"/PIData/master"
if [ -e "$WORKING_DIR" ]
then
    echo "running"
else
    echo "master dir does not exist; process fit file(s) first"
    exit
fi
   
cd "$WORKING_DIR"
RESULT_DIR=AAVSO
mkdir "$RESULT_DIR"
SOLVED_DIR=$WORKING_DIR"/$RESULT_DIR"
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
