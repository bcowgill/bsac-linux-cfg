#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
if which diffmerge > /dev/null; then
	diffmerge --nosplash $*
else
	if which diffmerge.sh > /dev/null; then
		diffmerge.sh $*
	else
		if which sgdm.exe > /dev/null; then
			sgdm.exe "$1" "$2"
		else
			if which kdiff3.exe > /dev/null; then
				kdiff3.exe "$1" "$2"
			fi
		fi
	fi
fi
