#!/bin/bash
#
# read-MAO-dir-list-filename-rename.sh
#
# 20 Dec 2023
#
# Each line should be in the following format (year month date var), e.g., 2023 12 25 M Crux.
# This should only be called when there are *.fit files in the PIData/AAVSO directory.
#
# Script to read list of MAO directories and rename files in PIData/AAVSO folder 
# by appending date to filename. 
# (e.g., PIData/AAVSO/M Crux 10.00s_FILTER-B_mono_FILTER-B.fit 
#  ----> PIData/AAVSO/M Crux 10.00s_FILTER-B_mono_FILTER-B_20231225.fit  )
#
#
input_file=$1
while read line
do
	if [[ "$line" != "#"* ]]; then
		IFS=' '
		read -a strarr <<< "$line"
		if [ ${#strarr[*]} -ne 5 ]; then
	    	echo "Incorrect MAO sub-directory format (e.g., 2023 12 25 M Crux)"
		    continue
		fi

		echo "Preping: ${strarr[0]} ${strarr[1]} ${strarr[2]} ${strarr[3]} ${strarr[4]}"
		./wrapper-filename-rename.sh "${strarr[0]}" "${strarr[1]}" "${strarr[2]}" "${strarr[3]}" "${strarr[4]}"
	fi
done < "$input_file"
