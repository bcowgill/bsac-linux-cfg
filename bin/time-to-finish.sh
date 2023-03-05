#!/bin/bash

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] hours-last size-last size-now

This will project at what time some task will finish given how long it took last time, and how far along it is currently.

hours-last The number of hours it took the task last time it ran.
size-last  The size of the job last time in any units you like, number of files, file size, etc. (default 100 for percentage)
size-now   The current size that has been output or percentate done, etc.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

Will output the number of hours remaining in the job based on the values given.  It will then project an ending time based on what the current time is.

See also dateAdd.js calc
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

HOURS_LAST=$1
SIZE_LAST=${2:-100}
SIZE_NOW=$3

if [ -z "$1" ]; then
	echo You must supply an hours-last value to base the estimated time remaining on.
	usage 0
fi

if [ -z "$3" ]; then
	echo You must supply a size-now value to compute the estimated time remaining.
	usage 0
fi

PERCENT=`calc "100*$SIZE_NOW/$SIZE_LAST" | perl -pne 's{\s*~}{}xms'`
HOURS_LEFT=`calc "$HOURS_LAST*(1-$SIZE_NOW/$SIZE_LAST)" | perl -pne 's{\s*~}{}xms'`
DAYS_LEFT=`calc "$HOURS_LEFT/24" | perl -pne 's{\s*~}{}'`

echo $PERCENT % complete
echo $HOURS_LEFT hours remain for the task from projected $HOURS_LAST hours last time.
dateAdd.js $DAYS_LEFT
