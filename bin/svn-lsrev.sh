#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# Show what files were changed in a specific revision vs the previous one
REV=$1
if [ "x$2" == "x" ] ; then
	let REV_PREV=$REV-1
else
	REV_PREV=$2
fi
echo Changes from revision $REV_PREV to $REV
svn diff --summarize -r$REV_PREV:$REV

