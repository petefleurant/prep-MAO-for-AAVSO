#! /bin/bash

# index-5000-*
for ((i=0; i<48; i++)); do
    I=$(printf %02i $i)
    wget https://portal.nersc.gov/project/cosmo/temp/dstn/index-5200/LITE/index-5200-$I.fits
done

# index-5001-*
for ((i=0; i<48; i++)); do
    I=$(printf %02i $i)
    wget https://portal.nersc.gov/project/cosmo/temp/dstn/index-5200/LITE/index-5201-$I.fits
done

# index-5002-*
for ((i=0; i<48; i++)); do
    I=$(printf %02i $i)
    wget https://portal.nersc.gov/project/cosmo/temp/dstn/index-5200/LITE/index-5202-$I.fits
done