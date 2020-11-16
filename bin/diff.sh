#!/bin/bash
# diff or reverse/sync diff if third parameter given
# WINDEV tool useful on windows development machine

function usage {
	echo "
Usage: $(basename $0) file1 file2 [--reverse|--sync|--cross|--refactor]

This will visually diff two files forward, reverse or both for refactoring.

--reverse or reverse  will diff the files in reverse order.
1 is an alias for --reverse
--sync or sync  will diff the files forward and reverse twice if they differ.
--cross or cross  is an alias for --sync
--refactor or refactor  is an alias for --sync

Any other third option provided will do a forward diff of the files.
"
	exit 0
}

[ ! -z "$2" ] || usage

case $3 in
	1)          DIFF=rvdiff;;
	reverse)    DIFF=rvdiff;;
	--reverse)  DIFF=rvdiff;;
	sync)       DIFF=xvdiff;;
	--sync)     DIFF=xvdiff;;
	cross)      DIFF=xvdiff;;
	--cross)    DIFF=xvdiff;;
	refactor)   DIFF=xvdiff;;
	--refactor) DIFF=xvdiff;;
	*)          DIFF=diff;;
esac

diff ()
{
	vdiff.sh "$1" "$2"
}

rvdiff ()
{
	vdiff.sh "$2" "$1"
}

xvdiff ()
{
	xvdiff.sh "$1" "$2"
}

$DIFF "$1" "$2"

