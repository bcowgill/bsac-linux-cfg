#!/bin/bash
# Run fortune command and guarantee some output unless there are errors
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
OUT=`mktemp`
ERR=`mktemp`
LINES=0

while [ 0 == $LINES ]; do
	fortune $* 2> $ERR > $OUT
	if [ 0 == `cat $ERR | wc -l` ]; then
		LINES=`cat $OUT | wc -l`
		if [ 0 != $LINES ]; then
			cat $OUT
			rm $OUT $ERR
			exit 0
		fi
	else
		cat $ERR 1>&2
		rm $OUT $ERR
		exit 1
	fi
done
