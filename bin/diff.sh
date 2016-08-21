#!/bin/bash
# diff or reverse diff if third parameter given
if [ -z "$3" ]; then
	DIFF=diff
else
	DIFF=rvdiff
fi

diff ()
{
	diffmerge --nosplash "$1" "$2"
}

rvdiff ()
{
	diffmerge --nosplash "$2" "$1"
}

$DIFF "$1" "$2"

