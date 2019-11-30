#!/bin/bash
# move files with a given year number in them into a year directory.

if [ -z "$1" ]; then
	echo "
usage: $(basename $0) year

Moves files or directories with the given year number in their name into a year subdirectory
"
	exit 1
fi

Y=$1
mkdir $Y > /dev/null
for f in *$Y*
do
	if [ "$f" != "$Y" ]; then
		mv "$f" $Y/
	fi
done

