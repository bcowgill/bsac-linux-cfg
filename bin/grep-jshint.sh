#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# grep the jshint messages for some text
# See also grep-jshint.sh jshint-add-complexity.sh jshint-analyse-complexity.sh jshint-json.sh jshint-js.sh jshint-set-complexity-js.sh jshint-tests.sh

if [ -z "$1" ]; then
	echo You must provide some words from a jshint message to find where it came from.
	echo For example $0 W001
	exit 1
fi

SEARCH="$*"
MESSAGES=`find node_modules -name messages.js | grep jshint | head -1`
OPTIONS=`find node_modules -name options.js | grep jshint | head -1`
JSHINT=`find node_modules -name jshint.js | head -1`
if [ ! -f $MESSAGES ]; then
	MESSAGES=`locate --regex 'messages.js$' | grep /node_modules/grunt-contrib-jshint/ | perl -pne 's{\A(.*)\z}{length($1) . " $1" }xmse' | sort -g | perl -pne 's{\A \d+ \s}{}xms' | head -1`
fi
if [ ! -f $OPTIONS ]; then
	OPTIONS=`locate --regex 'options.js$' | grep /node_modules/grunt-contrib-jshint/ | perl -pne 's{\A(.*)\z}{length($1) . " $1" }xmse' | sort -g | perl -pne 's{\A \d+ \s}{}xms' | head -1`
fi
if [ ! -f $JSHINT ]; then
	JSHINT=`locate --regex 'jshint.js$' | grep /node_modules/grunt-contrib-jshint/node_modules/ | perl -pne 's{\A(.*)\z}{length($1) . " $1" }xmse' | sort -g | perl -pne 's{\A \d+ \s}{}xms' | head -1`
fi
#grep -i "$*" "$MESSAGES" || grep -i "$*" "$JSHINT" || (echo nothing found in $MESSAGES or $JSHINT)

function check {
	local file search out
	file="$1"
	search="$2"
	out=`mktemp`
	echo "Checking $file:"
	grep -i "$search" "$file"
	rm $out
}

check "$MESSAGES" "$SEARCH"
check "$OPTIONS" "$SEARCH"
check "$JSHINT" "$SEARCH"
