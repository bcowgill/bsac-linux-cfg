#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# reverse move give a destination first then file/pattern good for sending a number of files to the same place in successive commands.
# see also rvcp.sh put.sh
if which sw_vers > /dev/null 2>&1 ; then
	# on MACOS
	mv "$2" "$1"
else
	mv -t "$1" "$2"
fi
# MUSTDO windows/git bash?
