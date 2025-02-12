#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

function usage {
	local code
	code=${1:-0}
	echo Supply a file name for find to locate and then edit.
	exit $code
}
if [ -z "$1" ]; then
	usage 1
fi
if [ "$1" == "--help" ]; then
	usage 1
fi
if [ "$1" == "--man" ]; then
	usage 1
fi
if [ "$1" == "-?" ]; then
	usage 1
fi
vim `find . -type f -name $1`

