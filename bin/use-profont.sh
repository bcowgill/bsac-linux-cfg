#!/bin/bash
# use-profont.sh -i.bak file.css
# use-profont.sh -i.bak `find . -name '*.css'`

if [ -z "$1" ]; then
	echo Usage: $0 [-i.bak] file ...
	echo Change CSS font-family to use profont.
	echo Example:
	echo $0 -i.bak \`find . -name \'\*.css\'\`
	exit 1
fi
perl -pne 'BEGIN { $/ = undef; } s{font-family \s* : [^;]+;}{font-family: ProFontWindows, monospace;}xmsg;' $*

