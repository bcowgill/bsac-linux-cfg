#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# grep the unicode utf8 name file for a character
# WINDEV tool useful on windows development machine
egrep -i --text --no-filename "$*" ~/bin/data/unicode/unicode-names.txt
