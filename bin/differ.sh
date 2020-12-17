#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# Not sure what kind of diffing capabilities are available so
# try to figure it out.

# Assume non-gui, must wait for each diff to finish before another
# started and they cannot diff dirs. Output piped to less for paging
DIFFERWAIT='| less -R'
DIFFERDIRS=0
DIFFERGUI=0

DIFFER=`which ${1:-nosuchdifferprogram}`

[ -z $DIFFER ] && DIFFER=`which diffmerge`
[ -z $DIFFER ] && DIFFER=`which meld`
[ -z $DIFFER ] && DIFFER=`which vimdiff`
[ -z $DIFFER ] && DIFFER=`which colordiff`
[ -z $DIFFER ] && DIFFER=`which diff`

if echo $DIFFER | egrep 'diffmerge|meld' > /dev/null ; then
	# meld and diffmerge can do directory diffs and run in background
	# because they are x windows apps
	DIFFERWAIT='&'
	DIFFERDIRS=1
	DIFFERGUI=1
fi

if echo $DIFFER | grep diffmerge > /dev/null ; then
	DIFFER="$DIFFER --nosplash"
fi
if echo $DIFFER | grep vimdiff > /dev/null ; then
	DIFFERWAIT=";"
fi

echo "DIFFER: $DIFFER new old $DIFFERWAIT # Dirs? $DIFFERDIRS GUI? $DIFFERGUI"
export DIFFER DIFFERWAIT DIFFERDIRS DIFFERGUI
