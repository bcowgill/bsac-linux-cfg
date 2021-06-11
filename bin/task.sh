#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine
# CUSTOM settings you may have to change on a new computer
if [ -d ~/workspace ]; then
	FILE=~/workspace/timeclock.txt
else
	FILE=~/timeclock.txt
fi

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd what task ID/description of what you are working on [--help|--man|-?]

This will make a record in your timeclock file [$FILE] that you started working on a specific task.
You can use that to track how your work is progressing.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

See also punch-in.sh punch-out.sh task.sh, waste.sh, mad.sh, glad.sh, sad.sh

Example:

task.sh TICKET-231 formatting HTML output for report page.
"
	exit $code
}
if [ "$1" == "--help" ]; then
	usage 0
fi
if [ "$1" == "--man" ]; then
	usage 0
fi
if [ "$1" == "-?" ]; then
	usage 0
fi

NOW=`( datestamp.sh ; date +%a ) | perl -pne "s{\n}{ }xms; END { print qq{\n}}"`
if [ "" == "$*" ]; then
	echo What amazing thing are you working on, please tell me again.
	echo or review your notes with:
	echo less $FILE
	echo You last worked on:
	grep 🚀  $FILE | tail -3
	exit 1
fi
echo working on task 🚀  "$*" at $NOW. saved to $FILE
echo task 🚀  "$*" at $NOW >> $FILE
