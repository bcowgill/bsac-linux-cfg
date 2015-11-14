#!/bin/bash
# grep the unicode name file for a character
egrep -i --text --no-filename $* ~/bin/data/unicode/unicode-names.txt
