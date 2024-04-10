#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
DIFFMERGE_PATH=/Applications/DiffMerge.app
DIFFMERGE_EXE=${DIFFMERGE_PATH}/Contents/MacOS/DiffMerge

VSCODE_PATH=/Applications/Visual\ Studio\ Code.app 
VSCODE_EXE=${VSCODE_PATH}/Contents/MacOS/Electron

if [ -z "$DISPLAY" ]; then
	vimdiff "$2" "$1"
	ERR=$?
	echo "set your DISPLAY=:0 variable if you didn't want vimdiff..."
	exit $ERR
fi
if which diffmerge > /dev/null; then
	diffmerge --nosplash "$2" "$1"
	exit $?
fi
if which diffmerge.sh > /dev/null; then
	diffmerge.sh "$2" "$1"
	exit $?
fi
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
if [ -x "$VSCODE_EXE" ]; then
	exec ${VSCODE_EXE} --diff "$2" "$1"
	exit $?
fi
if [ -x $DIFFMERGE_EXE ]; then
	exec ${DIFFMERGE_EXE} --nosplash "$2" "$1"
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
