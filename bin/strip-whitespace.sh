#!/bin/bash
# WINDEV tool useful on windows development machine

if [ -z "$1" ]; then
	echo "
usage: $(basename $0) filename

Strips trailing whitespace on lines from the named file.
"
	exit 0
fi

perl -i.bak -pne 's{\s*\z}{\n}xmsg' "$1"
