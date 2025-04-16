#
# calc-AIRMASS.py
#
# 14 April 2025
# Handle case where fts files are in sub directories, as in T CrB case
#
#
# 26 Feb 2024   -- Include 'Ha' filter
# 26 Dec 2023   -- Include 'I' filter
# 28 Nov 2023
# 22 Nov 2023 
#
# Reads files in given <directory>. 
# Each file is in FITS (Flexible Image Transport System) format. 
# Read each file and get the value of AIRMASS that is in the FITS Header of each file.
# Calculate the average of the AIRMASS values read. 
# Given <master_directory>, get corresponding master file and enter the calculated average into 
# the FITS header key/value AIRMASS.
#
# In order to programmatically upload fits files to VPhot, TELESCOP and USERNAME
# must be valid. 
# So, add the following to the FITS header:
# TELESCOP='ATMoB MAO' / This is VPhot system name for the telescope (not Display name)
# USERNAME=='FPIA' / observer code of image list where fits file will appear
#
# 
# 
# 
import sys
import re
import os
import astropy
from astropy.io import fits

def calculate_average_airmass(directory, master_directory):
    airmass_B_values = []
    airmass_V_values = []
    airmass_I_values = []
    airmass_R_values = []
    airmass_HA_values = []
    # Loop through each file in the directory
    for filename in os.listdir(directory):
        filepath = os.path.join(directory, filename)

        # Check if filepath is a directory. If it is then pass it on to calculate_average_airmass (recursion)
        # (Sub directories used if images have different exposures, as in the T CrB case.)
        if os.path.isdir(filepath):
            # Loop through each file in the directory
            calculate_average_airmass(filepath, master_directory)
        else:
            # Check if the file is a FITS file
            if filename.endswith('.fts'):
                try:
                    # Open the FITS file and get the header
                    with fits.open(filepath, mode='update') as hdul:
                        print(f'Reading FITS file {filename}')
                        header = hdul[0].header
                        # Check if 'AIRMASS' is present in the header
                        if 'AIRMASS' in header:
                            airmass = header['AIRMASS']
                            #which filter is this
                            if 'FILTER' in header:
                                filter = header['FILTER']
                                if filter == 'B':
                                    airmass_B_values.append(airmass)
                                elif filter == 'V':
                                    airmass_V_values.append(airmass)
                                elif filter == 'I':
                                    airmass_I_values.append(airmass)
                                elif filter == 'R':
                                    airmass_R_values.append(airmass)
                                elif filter == 'Ha':
                                    airmass_HA_values.append(airmass)
                                else:
                                    print(f'Unrecognized filter found in header for file: {filename}')
                        else:
                            print(f'AIRMASS not found in header for file: {filename}')

                except Exception as e:
                    print(f'Error reading FITS file {filename}: {str(e)}')

    # Calculate the average of AIRMASS Filter B values
    airmass_value_exist = False
    if airmass_B_values:
        average_B_airmass = sum(airmass_B_values) / len(airmass_B_values)
        print(f'Average AIRMASS for B: {average_B_airmass}')
        airmass_value_exist = True
    else:
        print(f'No B filter FITS files with AIRMASS values found in the directory: {directory}')

    # Calculate the average of AIRMASS Filter V values
    if airmass_V_values:
        average_V_airmass = sum(airmass_V_values) / len(airmass_V_values)
        print(f'Average AIRMASS for V: {average_V_airmass}')
        airmass_value_exist = True
    else:
        print(f'No V filter FITS files with AIRMASS values found in the directory: {directory}')

    # Calculate the average of AIRMASS Filter I values
    if airmass_I_values:
        average_I_airmass = sum(airmass_I_values) / len(airmass_I_values)
        print(f'Average AIRMASS for I: {average_I_airmass}')
        airmass_value_exist = True
    else:
        print(f'No I filter FITS files with AIRMASS values found in the directory: {directory}')

    # Calculate the average of AIRMASS Filter I values
    if airmass_R_values:
        average_R_airmass = sum(airmass_R_values) / len(airmass_R_values)
        print(f'Average AIRMASS for R: {average_R_airmass}')
        airmass_value_exist = True
    else:
        print(f'No R filter FITS files with AIRMASS values found in the directory: {directory}')

    # Calculate the average of AIRMASS Filter Ha values
    if airmass_HA_values:
        average_HA_airmass = sum(airmass_HA_values) / len(airmass_HA_values)
        print(f'Average AIRMASS for Ha: {average_HA_airmass}')
        airmass_value_exist = True
    else:
        print(f'No Ha filter FITS files with AIRMASS values found in the directory: {directory}')

    if airmass_value_exist:
        #Read in the masters that were saved as fit files 
        for filename in os.listdir(master_directory):
            filepath = os.path.join(master_directory, filename)

            # Check if the file is a FITS file
            if filename.endswith('.fit'):
                #If data was from a sub directory, we only want the corresponding *SEC-<integer>.fit file
                #Example, sub dir: Sec_05; we want fit file ending in SEC-05
                subdir = directory.split("\\")[-1]
                if re.search("Sec_",subdir):
                    # we are in a sub directory, e.g., Sec_05
                    # get the trailing int
                    match = re.search(r'(\d+)$', subdir)
                    if match:
                        dir_trailing_number = int(match.group(1))
                        # get fit files with the ending SEC-<dir_trailing_number>
                        name_without_ext = os.path.splitext(filename)[0]
                        # Find trailing number
                        match = re.search(r'(\d+)$', name_without_ext)
                        if match:
                            file_trailing_number = int(match.group(1))
                            if dir_trailing_number != file_trailing_number:
                                continue

                try:
                    # Open the FITS file and get the header
                    with fits.open(filepath, mode='update') as hdul:
                        print(f'Reading FITS file {filename}')
                        header = hdul[0].header
                        # update TELESCOP and USERNAME so file  
                        # can be directly uploaded to VPhot
                        header['TELESCOP'] = 'ATMoB MAO' # This is VPhot system name for the telescope (not Display name)
                        header['USERNAME'] = 'FPIA' # observer code of image list where fits file will appear
                        #write in the calculated average
                        #which filter is this?
                        if 'FILTER' in header:
                            filter = header['FILTER']
                            if filter == 'B':
                                header['AIRMASS'] = round(average_B_airmass, 4)
                                print(round(average_B_airmass, 4))
                            elif filter == 'V':
                                header['AIRMASS'] = round(average_V_airmass, 4)
                                print(round(average_V_airmass, 4))
                            elif filter == 'I':
                                header['AIRMASS'] = round(average_I_airmass, 4)
                                print(round(average_I_airmass, 4))
                            elif filter == 'R':
                                header['AIRMASS'] = round(average_R_airmass, 4)
                                print(round(average_R_airmass, 4))
                            elif filter == 'Ha':
                                header['AIRMASS'] = round(average_HA_airmass, 4)
                                print(round(average_HA_airmass, 4))
                            else:
                                print(f'Unrecognized filter found in header for file: {filename}')
                        else:
                            print(f'FILTER not found in header for file: {filename}')

                except Exception as e:
                    print(f'Error reading FITS file {filename}: {str(e)}')


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python calculate_average_airmass <source_directory, master_directory>")
        exit
    else:
        source_directory = sys.argv[1]
        master_directory = sys.argv[2]
        calculate_average_airmass(source_directory, master_directory)

#Eg.,
#calculate_average_airmass('E:\\Astronomy\\AstronomyData\\MAO\\2023\\2023 11 14 BF Eri\\BF Eri-20231114', 'E:\\Astronomy\\AstronomyData\\MAO\\2023\\2023 11 14 BF Eri\\PIData\\master')
