#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit

if which diffmerge > /dev/null; then
	diffmerge --nosplash "$2" "$1"
else
	if which diffmerge.sh > /dev/null; then
		diffmerge.sh "$2" "$1"
	else
		if which sgdm.exe > /dev/null; then
			sgdm.exe "$2" "$1"
		else
			if which kdiff3.exe > /dev/null; then
				kdiff3.exe "$2" "$1"
			fi
		fi
	fi
fi
