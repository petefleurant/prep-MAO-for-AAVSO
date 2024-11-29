#
# ftp-to-VPhot.py
#
# 28 Nov 2023
#
# Uploads files from given directory to the ftp://vphot.aavso.org
# Each file is in FITS (Flexible Image Transport System) format with following 
# set in FITS header. 
# TELESCOP='ATMoB MAO' / This is VPhot system name for the telescope (not Display name)
# USERNAME=='FPIA' / observer code of image list where fits file will appear
# 
# 
import sys
from ftplib import FTP
import os

def upload_files_to_ftp(server, username, password, local_directory):
    # Connect to FTP server
    ftp = FTP(server)
    ftp.login(user=username, passwd=password)

    # Change to the remote directory (create it if it doesn't exist)
    #try:
    #    ftp.cwd(remote_directory)
    #except:
    #    ftp.mkd(remote_directory)
    #    ftp.cwd(remote_directory)

    # Upload files
    for filename in os.listdir(local_directory):
        local_path = os.path.join(local_directory, filename)
        if os.path.isfile(local_path):
            with open(local_path, 'rb') as file:
                ftp.storbinary('STOR ' + filename, file)

    # Close the FTP connection
    ftp.quit()

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python upload_files_to_ftp <local_directory>")
    else:
        local_directory_path = sys.argv[1]
        ftp_server = 'vphot.aavso.org'
        ftp_username = 'FPIA'
        ftp_password = 'L3p3&sH5w*Fw'
    upload_files_to_ftp(ftp_server, ftp_username, ftp_password, local_directory_path)
