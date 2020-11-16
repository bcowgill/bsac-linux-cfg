#!/bin/bash
# grep the unicode name file for a character
# WINDEV tool useful on windows development machine
egrep -i --text --no-filename "$*" ~/bin/data/unicode/unicode-names.txt
