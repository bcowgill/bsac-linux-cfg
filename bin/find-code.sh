#!/bin/bash
# find all files excluding .git node_modules and bower_components
# find-code.sh -o '\(' -name \'*.js\' -exec echo {} '\;' '\)'
# WINDEV tool useful on windows development machine

if [ -z "$1" ]; then
	ARGS="-o -print"
else
	ARGS="$*"
fi

echo find . '\(' \
	-name node_modules \
	-o -name .idea \
	-o -name coverage \
	-o -name bower_components \
	-o -name .git \
'\)' -prune $ARGS

find . \( \
	-name node_modules \
	-o -name .idea \
	-o -name coverage \
	-o -name bower_components \
	-o -name .git \
\) -prune $ARGS
