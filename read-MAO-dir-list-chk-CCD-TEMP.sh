#!/bin/bash
#
# read-MAO-dir-list-chk-CCD-TEMP.sh
#
# 29 Nov 2023
#
# Script to read list of MAO directories ansd call wrapper-chk-CCD-TEMP.sh for each line
# in given file.
# Each line should be in the following format (year month date var), e.g., 2023 12 25 M Crux.
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
		./wrapper-chk-CCD-TEMP.sh "${strarr[0]}" "${strarr[1]}" "${strarr[2]}" "${strarr[3]}" "${strarr[4]}"
	fi
done < "$input_file"