#!/bin/bash
# check for zero size files which have been blatted somehow
BLATTED=`find . \( -name node_modules -o -path ./dist \) -prune -o -size 0 | egrep -v '(/dist|node_modules|\.log$|\.timestamp$)'`
if [ ! -z "$BLATTED" ]; then
	echo WARNING some of your files are zero sized! have they been blatted?
	echo $BLATTED
	exit 1
fi
