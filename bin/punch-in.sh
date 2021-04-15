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
$cmd [--help|--man|-?]

This will make a record in your timeclock file [$FILE] that you started work for the day.
You can use that to track how your work is progressing.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

See also punch-in.sh punch-out.sh task.sh, waste.sh, mad.sh, glad.sh, sad.sh

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
echo punched in at $NOW. saved to $FILE
echo in at $NOW >> $FILE
