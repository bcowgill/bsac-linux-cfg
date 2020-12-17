#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# use-profont.sh -i.bak file.css
# use-profont.sh -i.bak `find . -name '*.css'`

if [ -z "$1" ]; then
	echo "
usage: $(basename $0) [-i.bak] file ...

Change CSS font-family to use profont.

Example:
	$(basename $0) -i.bak \`find . -name \'\*.css\'\`
"
	exit 1
fi
perl -pne 'BEGIN { $/ = undef; } s{font-family \s* : [^;]+;}{font-family: ProFontWindows, monospace;}xmsg;' $*

