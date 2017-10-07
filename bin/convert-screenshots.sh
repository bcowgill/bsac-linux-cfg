#!/bin/bash
# Convert all ppm files in snapshots dir to png files
# good for a cronjob

# sudo apt-get install fbcat imagemagick
# grab a screenshot after 5 seconds
# fbgrab -s 5 -d /dev/fb0 -i sleepshot.png &
# sudo fbcat > console-snapshot.ppm

DIR=$HOME/Pictures/_snapshots
for file in $DIR/*.ppm; do
	output=`basename "$file" .ppm`
	FILE="$DIR/$output.png"
	if [ -f "$FILE" ]; then
		true
		#echo $FILE already exists, will not convert.
	else
		touch "$FILE"
		convert "$file" "$FILE"
	fi
done
