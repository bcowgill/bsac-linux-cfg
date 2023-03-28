#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine
# CUSTOM settings you may have to change on a new computer

# requires datestamp.sh

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
$cmd reasons that you are mad [--help|--man|-?]

This will make a record in your timeclock file [$FILE] that you were mad about something during the day/sprint.
You can then bring that up at the retrospective meeting.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

See also punch-in.sh punch-out.sh task.sh waste.sh mad.sh glad.sh sad.sh

Example:

mad.sh Code was released without peer review and production when down.
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
	echo Why are you mad, please tell me again.
	echo or review your notes with:
	echo less $FILE
	echo You last mentioned:
	grep 😡 $FILE | tail -3
	exit 1
fi
echo mad 😡  because "$*" at $NOW. saved to $FILE
echo mad 😡  "$*" at $NOW >> $FILE

exit 0
