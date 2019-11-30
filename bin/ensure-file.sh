#!/bin/bash
# Ensure that a file exists by touching it and creating the directory path if needed.

if [ -z "$1" ]; then
	echo "
usage: $(basename $0) path-to-filename

This is like a simple touch, but ensures that the file will exist if the directory doesn't.
"
	exit 1
fi

DIR=`dirname $1`

#echo DIR=$DIR

[ -d "$DIR" ] || mkdir -p "$DIR"
touch "$1"

