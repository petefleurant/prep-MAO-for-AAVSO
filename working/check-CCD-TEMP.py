#
# check-CCD-TEMP.py
#
# 26 Nov 2023 
# 
# Reads files in a given directory where each file is in FITS (Flexible Image Transport System) format. 
# Read each file and get the value of CCD-TEMP and check against input parameter <nominal-temp>
# If more than 2 degree difference, then print out difference.
#
import sys
import os
import astropy
from astropy.io import fits

def check_CCD_TEMP(directory, nominal_temp):
    # Loop through each file in the directory
    for filename in os.listdir(directory):
        filepath = os.path.join(directory, filename)

        # Check if the file is a FITS file
        if filename.endswith('.fts'):
            try:
                # Open the FITS file and get the header
                with fits.open(filepath, mode='update') as hdul:
                    print(f'Reading FITS file {filename}')
                    header = hdul[0].header
                    # Check if 'CCD-TEMP' is present in the header
                    if 'CCD-TEMP' in header:
                        ccd_temp = header['CCD-TEMP']
                        temp_diff = abs(float(ccd_temp) - nominal_temp)
                        if  temp_diff > 2 :
                            print(f'>2 degree temp diff in file: {filename}; temp diff = {temp_diff}')
                    else:
                        print(f'CCD-TEMP not found in header for file: {filename}')

            except Exception as e:
                print(f'Error reading FITS file {filename}: {str(e)}')



if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python check_CCD_TEMP <source_directory, nominal_temp>")
    else:
        source_directory = sys.argv[1]
        nominal_temp = sys.argv[2]
    check_CCD_TEMP(source_directory, nominal_temp)
