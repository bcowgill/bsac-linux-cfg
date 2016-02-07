#!/bin/bash
# move files with a year number in them into a year directory.
Y=$1
mkdir $Y > /dev/null
for f in *$Y*
do
	if [ "$f" != "$Y" ]; then
		mv "$f" $Y/
	fi
done

