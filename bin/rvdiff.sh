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
			else
				DIFFMERGE_PATH=/Applications/DiffMerge.app
				DIFFMERGE_EXE=${DIFFMERGE_PATH}/Contents/MacOS/DiffMerge
				if [ -x $DIFFMERGE_EXE ]; then
					exec ${DIFFMERGE_EXE} --nosplash "$2" "$1"
				else
					exit 1
				fi
			fi
		fi
	fi
fi
