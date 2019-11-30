#!/bin/bash

if [ -z "$1" ]; then
	echo "
usage: $(basename $0) filename

Strips trailing whitespace on lines from the named file.
"
	exit 0
fi

perl -i.bak -pne 's{\s*\z}{\n}xmsg' "$1"
