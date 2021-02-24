#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# find all files excluding .git node_modules and bower_components
# find-code.sh -o '\(' -name \'*.js\' -exec echo {} '\;' '\)'
# See also grepcode.sh find-bak.sh
# WINDEV tool useful on windows development machine

if [ -z "$1" ]; then
	ARGS="-o -print"
else
	ARGS="$*"
fi

echo find . '\(' \
	-name .tmp \
	-o -name .git \
	-o -name .idea \
	-o -name dist \
	-o -name coverage \
	-o -name node_modules \
	-o -name bower_components \
'\)' -prune $ARGS

find . \( \
	-name .tmp \
	-o -name .git \
	-o -name .idea \
	-o -name dist \
	-o -name coverage \
	-o -name node_modules \
	-o -name bower_components \
\) -prune $ARGS
