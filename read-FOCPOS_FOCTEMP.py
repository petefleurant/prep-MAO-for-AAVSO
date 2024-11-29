#
# chk-FOCPOS_FOCTEMP.py
#
# 8 June 2024
#
# Reads files in given <directory>. 
# Each file is in FITS (Flexible Image Transport System) format. 
# Read each file and get the value of FOCPOS, FOCTEMP, and DATE-LOC that are in the FITS Header of each file.
# Print them out as CSVs
#
# 
# 
import sys
import os
import astropy
from astropy.io import fits

def read_FOCTEMP(directory):
    # Loop through each file in the directory
    for filename in os.listdir(directory):
        filepath = os.path.join(directory, filename)

        # Check if the file is a FITS file
        if filename.endswith('.fit'):
            try:
                # Open the FITS file and get the header
                with fits.open(filepath, mode='update') as hdul:
                    #print(f'Reading FITS file {filename}')
                    header = hdul[0].header
                    # Make sure 'CCD-TEMP' and 'SET-TEMP' are present in the header
                    if 'FOCPOS' in header and 'FOCTEMP' in header:
                        foc_pos = header['FOCPOS']
                        foc_temp = header['FOCTEMP']
                        foc_time = header['DATE-LOC']
                        print(f'DATA, {foc_pos}, {foc_temp}, {foc_time}')
                    else:
                        print(f'FOCPOS and/or FOCTEMP not found in header for file: {filename}')
                    hdul[0].verify('ignore')
            except Exception as e:
                print(f'Error reading FITS file {filename}: {str(e)}')

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python check_FOCTEMP <source_directory>")
    else:
        source_directory = sys.argv[1]
    read_FOCTEMP(source_directory)
#Eg.,
#read_FOCTEMP('E:\\Astronomy\\AstronomyData\\MAO\\2023\\2023 11 14 BF Eri\\BF Eri-20231114')
