#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# refactor two named files by diffing them A vs B then B vs A
# a primitive version of xvdiff.sh
# WINDEV tool useful on windows development machin

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

