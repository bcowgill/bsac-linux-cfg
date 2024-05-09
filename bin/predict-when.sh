#!/bin/bash
#BSAC Todo

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] "start-time" total current

This will calculate a predicted end date/time given a start date/time, total size and current size values.

start-time  A starting date/time in a format that a javascript date supports.
total       The total size of the operation that started at the start-time.
current     The current size processed which we want to use to predict the end time.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

More detail ...

See also time-to-finish.sh dateAdd.js

Example:

...
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
if echo "$*" | grep -- "--" > /dev/null; then
	echo "unknown parameter provided, please study the command usage below."
	echo ""
	usage 1
fi

START="$1"
TOTAL="$2"
SIZE="$3"

if [ -z "$START" ]; then
	echo "you must provide a start time in an acceptable Javascript new Date() format."
	usage 2
fi

if [ -z "$TOTAL" ]; then
	echo "you must provide a total size, length, duration or other quantity to predict the finish date/time."
	usage 3
fi

if [ -z "$SIZE" ]; then
	echo "you must provide a current size, length, duration or other quantity to predict the finish date/time."
	usage 4
fi

hours=`dateDaysBetween.js hours "$START" | perl -pne 's{h}{}xms'`
current=`echo $SIZE | perl -pne 's{,}{}xmsg; s{\A\s*([0-9.]+).*\z}{$1}xms;'`
total=`echo $TOTAL | perl -pne 's{,}{}xmsg; s{\A\s*([0-9.]+).*\z}{$1}xms;'`
duration=`perl -e "\\$value = $total * $hours / (24 * $current); print qq{\\$value}"`
echo $current / $total portion done.
echo $hours hours elapsed so far.
echo $duration days for total operation to complete.
dateAdd.js "$START" $duration
