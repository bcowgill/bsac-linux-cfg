#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

if [ -z "$1" ]; then
	echo Supply a file name for find to locate and then edit.
	exit 1
fi
vim `find . -type f -name $1`

