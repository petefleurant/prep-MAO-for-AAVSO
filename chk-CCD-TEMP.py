#
# chk-CCD-TEMP.py
#
# 14 April 2025
# Handle case where fts files are in sub directories, as in T CrB case
#
# 29 Nov 2023
#
# Reads files in given <directory>. 
# Each file is in FITS (Flexible Image Transport System) format. 
# Read each file and get the value of CCD-TEMP and SET-TEMP that is in the FITS Header of each file.
# Calculate the difference |CCD-TEMP - SET-TEMP| and if > 2, print out File name and difference.
#
# 
# 
import sys
import os
import astropy
from astropy.io import fits

def check_file_CCD_TEMP(image_filepath, image_filename):
    try:
        # Open the FITS file and get the header
        with fits.open(image_filepath, mode='update') as hdul:
            #print(f'Reading FITS file {filename}')
            header = hdul[0].header
            # Make sure 'CCD-TEMP' and 'SET-TEMP' are present in the header
            if 'CCD-TEMP' in header and 'SET-TEMP' in header:
                ccd_temp = header['CCD-TEMP']
                set_temp = header['SET-TEMP']
                if abs(ccd_temp - set_temp) > 1.0:
                    #print out warning
                    print(f'!!!!WARNING File: {image_filename} has possible bad temperature')
                    print(f'CCD-TEMP = {ccd_temp}')
                    print(f'SET-TEMP = {set_temp}')
                    print('!!!!WARNING')
            else:
                print(f'CCD-TEMP and/or SET-TEMP not found in header for file: {image_filename}')
    except Exception as e:
        print(f'Error reading FITS file {image_filename}: {str(e)}')


def check_CCD_TEMP(directory):
    # Loop through each file in the directory
    for filename in os.listdir(directory):
        filepath = os.path.join(directory, filename)

        # Check if filepath is a directory. If it is then pass it on to check_CCD_TEMP (recursion)
        # (Sub directories used if images have different exposures, as in the T CrB case.)
        if os.path.isdir(filepath):
            # Loop through each file in the directory
            check_CCD_TEMP(filepath)
        else:
            # Check if the file is a FITS file
            if filename.endswith('.fts'):
                check_file_CCD_TEMP(filepath, filename)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python check_CCD_TEMP <source_directory>")
        exit
    else:
        source_directory = sys.argv[1]
        check_CCD_TEMP(source_directory)
#Eg.,
#check_CCD_TEMP('E:\\Astronomy\\AstronomyData\\MAO\\2023\\2023 11 14 BF Eri\\BF Eri-20231114')
