#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
if which sgdm.exe > /dev/null; then
	sgdm.exe "$2" "$1"
	exit $?
fi
if which bcomp.exe > /dev/null; then
	bcomp.exe "$2" "$1"
	exit $?
fi
if which kdiff3.exe > /dev/null; then
	kdiff3.exe "$2" "$1"
	exit $?
fi
if which winmergeu > /dev/null; then
	winmergeu "$2" "$1"
	exit $?
fi
if which code > /dev/null; then
	code --diff "$2" "$1"
	exit $?
fi
if which meld > /dev/null; then
	meld "$2" "$1"
	exit $?
fi
exit 1
