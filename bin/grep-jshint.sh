#!/bin/bash
# grep the jshint messages for some text

MESSAGES=`locate --regex 'messages.js$' | grep /node_modules/grunt-contrib-jshint/ | perl -pne 's{\A(.*)\z}{length($1) . " $1" }xmse' | sort -n | perl -pne 's{\A \d+ \s}{}xms' | head -1`
grep -i "$*" "$MESSAGES"
