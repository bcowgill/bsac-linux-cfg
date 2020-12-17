#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
if which diffmerge > /dev/null; then
	diffmerge --nosplash $*
else
	if which diffmerge.sh > /dev/null; then
		diffmerge.sh $*
	fi
fi
# windows...
# kdiff3.exe "$1" "$2"
