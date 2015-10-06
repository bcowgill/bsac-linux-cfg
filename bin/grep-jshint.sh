#!/bin/bash
# grep the jshint messages for some text

MESSAGES=node_modules/grunt-contrib-jshint/node_modules/jshint/src/messages.js
JSHINT=node_modules/grunt-contrib-jshint/node_modules/jshint/src/jshint.js
if [ ! -f $MESSAGES ]; then
	MESSAGES=`locate --regex 'messages.js$' | grep /node_modules/grunt-contrib-jshint/ | perl -pne 's{\A(.*)\z}{length($1) . " $1" }xmse' | sort -n | perl -pne 's{\A \d+ \s}{}xms' | head -1`
fi
if [ ! -f $JSHINT ]; then
	JSHINT=`locate --regex 'jshint.js$' | grep /node_modules/grunt-contrib-jshint/node_modules/ | perl -pne 's{\A(.*)\z}{length($1) . " $1" }xmse' | sort -n | perl -pne 's{\A \d+ \s}{}xms' | head -1`
fi
grep -i "$*" "$MESSAGES" || grep -i "$*" "$JSHINT" || (echo nothing found in $MESSAGES or $JSHINT)
