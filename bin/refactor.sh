#!/bin/bash
# refactor two named files by diffing them A vs B then B vs A
# a primitive version of xvdiff.sh

DIFF=refactor

diff ()
{
	vdiff.sh "$1" "$2"
}

rvdiff ()
{
	vdiff.sh "$2" "$1"
}

refactor ()
{
	diff "$1" "$2"
	rvdiff "$1" "$2"
}

refactor "$1" "$2"

