#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# See also punch-in.sh punch-out.sh task.sh, waste.sh, mad.sh, glad.sh, sad.sh
# WINDEV tool useful on windows development machine
# CUSTOM settings you may have to change on a new computer
if [ -d ~/workspace ]; then
	FILE=~/workspace/timeclock.txt
else
	FILE=~/timeclock.txt
fi
NOW=`( datestamp.sh ; date +%a ) | perl -pne "s{\n}{ }xms; END { print qq{\n}}"`
echo glad ☺  because "$*" at $NOW. saved to $FILE
echo glad ☺  "$*" at $NOW >> $FILE
