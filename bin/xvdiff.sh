#!/bin/bash

function usage {
	if [ ! -z "$1" ]; then
		echo "Error: $1"
	fi
	echo "
Usage: $(basename $0) file1 file2

This will cross-synchronise two files by back and forth diffing.  It will create the one that is missing, so be accurate in specifying file names.

It will give you two chances to visually diff file1 with file2 then file2 with file1 and it will stop if the files are identical at any point.
"
	if [ ! -z "$1" ]; then
		exit 1
	fi
	exit 0
}

if [ -z "$2" ]; then
	usage
fi

[ -e "$1" ] || [ -e "$2" ] || usage "at least one of the files must exist."

[ -e "$1" ] || touch "$1"
[ -e "$2" ] || touch "$2"

function mydiff {
	if diff "$1" "$2" > /dev/null; then
		echo "files are identical"
		exit 0
	else
		vdiff.sh "$1" "$2"
	fi
}

mydiff "$1" "$2"
mydiff "$2" "$1"
mydiff "$1" "$2"
mydiff "$2" "$1"
