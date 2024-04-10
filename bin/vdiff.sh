#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
DIFFMERGE_PATH=/Applications/DiffMerge.app
DIFFMERGE_EXE=${DIFFMERGE_PATH}/Contents/MacOS/DiffMerge

VSCODE_PATH=/Applications/Visual\ Studio\ Code.app 
VSCODE_EXE=${VSCODE_PATH}/Contents/MacOS/Electron

if [ -z "$DISPLAY" ]; then
	vimdiff "$1" "$2"
	ERR=$?
	echo "set your DISPLAY=:0 variable if you didn't want vimdiff..."
	exit $ERR
fi
if which diffmerge > /dev/null; then
	diffmerge --nosplash "$1" "$2"
	exit $?
fi
if which diffmerge.sh > /dev/null; then
	diffmerge.sh "$1" "$2"
	exit $?
fi
if which sgdm.exe > /dev/null; then
	sgdm.exe "$1" "$2"
	exit $?
fi
if which bcomp.exe > /dev/null; then
	bcomp.exe "$1" "$2"
	exit $?
fi
if which kdiff3.exe > /dev/null; then
	kdiff3.exe "$1" "$2"
	exit $?
fi
if which winmergeu > /dev/null; then
	winmergeu "$1" "$2"
	exit $?
fi
if [ -x "$VSCODE_EXE" ]; then
	exec ${VSCODE_EXE} --diff "$1" "$2"
	exit $?
fi
if [ -x $DIFFMERGE_EXE ]; then
	exec ${DIFFMERGE_EXE} --nosplash "$1" "$2"
	exit $?
fi
if which code > /dev/null; then
	code --diff "$1" "$2"
	exit $?
fi
if which meld > /dev/null; then
	meld "$1" "$2"
	exit $?
fi
exit 1
