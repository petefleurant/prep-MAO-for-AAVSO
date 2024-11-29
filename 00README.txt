Procedure for managing Mittelman ATMoB Observatory (MAO) images for AAVSO submission.
Scripts are run using bash and python in the UNIX based cygwin environment: 
E:\cygwin64\$HOME\prep-MAO-for-AAVSO or ~/prep-MAO-for-AAVSO.     (HOME = /home/Owner; or = /home/PeteAndSue; or...)


Quick Instructions:
cd ~/prep-MAO-for-AAVSO
./read-MAO-dir-list.sh ./Common_list.txt
./read-MAO-dir-list-chk-CCD-TEMP.sh ./Common_list.txt
#Calibrate in PixInsight
./read-MAO-dir-list-image-solve.sh ./Common_list.txt
./read-MAO-dir-list-calc-AIRMASS.sh ./Common_list.txt
./read-MAO-dir-list-filename-rename.sh ./Common_list.txt
./read-MAO-dir-list-ftp-to-VPhot.sh ./Common_list.txt


Detailed Instructions:

1)	Save a “Common_list.txt” file in ~/prep-MAO-for-AAVSO containing the list of image sets. 
	Example:
		2023 10 08 V347 Aur
		2023 10 08 CH Cyg
		#2023 10 08 AG Dra 
		2023 10 08 S Gem
		2023 10 08 AutoFlat 20   # the 20 is -20 celsius

	The line beginning with '#' is ignored
2)	cd ~/prep-MAO-for-AAVSO
3)	execute ./read-MAO-dir-list.sh ./Common_list.txt; This creates directories and
	copies MAO files from MAO’s Google drive to local machine
		Source directories are listed:
			"$HOME/AstronomyData/MAO"
			"$HOME/AAVSO Reports/MAO"
	Note: AutoFlats are not created every day, to automatically download the autoflat 
	use an entry suach as "2023 10 08 AutoFlat 20" and the B and V flats (only) are copied to directory: "E:\Astronomy\AstronomyData\MAO\00CalibrationFiles\Flats\minus 20\2023 10 08"
4)	execute ./read-MAO-dir-list-chk-CCD-TEMP.sh ./Common_list.txt; This will flag any out of spec CCD-TEMP values
5)	open PixInsight, inspect, and create project (modify an existing one). 
6)	In PixInsight, run WBPP to calibrate the B and V images, register, then integrate (stack)
	a.	WBPP is run WITHOUT any weighting;
		Grouping Keywords: FILTER (pre and post)
		Registration Ref Image: auto by FILTER
		Bias: Average; Auto
		Darks: Average Auto
		Flats: Average; Auto
		Lights: Subframe Weighting: OFF
				Image Registration: Nearest Neighbor
				Image Integration: Average; Min weight: .005; Autocrop: OFF
				Presets: Fastest with lower quality
	b.	Registration is NEAREST NEIGHBOR, B and V are registered and stacked with same FILTER do there are 2 masters created, B and V.
	c.	Integration is AUTO
7)	In PixInsight, open master B and V Lights; inspect, then drop SaveAsFit script
8)	Repeat steps 6 thru 8 for all Vars imaged.
9)	execute ./read-MAO-dir-list-image-solver.sh ./Common_list.txt; This creates FIT files with WCS in PIData/master/AAVSO from the SaveAsFit results in PIData/master
10)	execute ./read-MAO-dir-list-calc-AIRMASS.sh ./Common_list.txt; This updates the AIRMASS value of the FITS file to the average of all the stacked images’ AIRMASS values
11)	execute ./read-MAO-dir-list-filename-rename.sh ./Common_list.txt; This appends date to filename of fit files so unique filenames get uploaded to VPhot
12)	execute ./read-MAO-dir-list-ftp-to-VPhot.sh ./Common_list.txt; This ftp's the AAVSO/*.fit files to VPhot's FTP server vphot.aavso.org
13)	execute “find ~/AstronomyData/MAO/2023/ -type f -name "*.xisf" -exec rm {} \;” to remove *.xisf files that are no longer needed (Fits files are kept)
14)	execute “find ~/AstronomyData/MAO/2023/ -type f -name "*.xdrz" -exec rm {} \;” this removes *.xdrz files (drizzle files)
15)	Proceed to VPhot and execute differential photometry on B,V pairs;
NOTE: In VPhot:  quote from Arne: "In my opinion, the sources that should be avoided are 2,3,4,5,6,7,13,14,15,16,23. If any of the stars 
you might want to use as a comparison star comes from one of these catalogs, ask the AST to investigate it.""


Notes:
ftp://vphot.aavso.org user: FPIA pw: L3p3&sH5w*Fw


From AB Aur Notes:
- Proceedure to process Ha and make ready for VPhot.
There is a problem such that astrometry.net's solve-field fails to solve the Ha image. To get around this 
the Ha images are registerd to the best V frame, then the V master's (in fit format) FIT header is copied to the Ha master's (in fit format) FIT header. Then the Filter is changed back to HA. To do this the following procedure is followed:
- execute WBPP "BV_Cal" with updated lights, flats, etc.
- find out which V (_c.xisf) was used for registration. Call it best_V. (Look in PIData/logs/ProcessLogger.txt)
- Run the remaining tasks and complete uploading to VPhot, in other words finish steps 5 through 12 in 00README.txt. DO NOT run step 13 and 14, do not delete *.xisf files.
- Come back to WBPP in Ha_Cal, update lights, then set "Registration Reference Image" to manual and insert best_V
- Save the Ha master as a FIT file (step 7 in 00README.txt)
- use AstroImageJ to copy FIT header
- edit FILTER and DATE-OBS
- Run read-MAO-dir-list-calc-AIRMASS.sh 
- Run read-MAO-dir-list-filename-rename.sh (only necessary if a file has same name on VPhot queue)
- Run read-MAO-dir-list-ftp-to-VPhot.sh
- finish with steps 13 and on in 00README.txt

