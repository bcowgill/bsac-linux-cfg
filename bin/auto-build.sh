#!/bin/bash
# auto rebuild when things change
TOUCH=last-build.timestamp
PAUSE=`pwd`/pause-build.timestamp
WATCHDIR=..
WAIT=6
TIMES=50
LOOPS=0
IGNORE='\.log$|\.swp$|\.bak$|~$|\.\#.*$|\#.+\#$|\.yml$|\.orig$|\.kate-swp$|/\.git/|/node_modules/|/public/doc/'
DEBUG=1

if [ -z "$1" ]; then
	echo Usage: $0 build-command [watch-dir]
	echo You must supply a build command to run.
	exit 1
fi
BUILD="$1"
if [ ! -z "$2" ]; then
	shift
	WATCHDIR="$*"
fi
echo BUILD=$BUILD
echo WATCHDIR="$WATCHDIR"
echo TOUCH=$TOUCH
echo IGNORE="$IGNORE"

function debug
{
	local message
	message=$1
	if [ ${DEBUG:-0} == 1 ]; then
		echo $message
	fi
}

while  [ /bin/true ]
do
	BUILDIT=0
	if [ ! -f "$PAUSE" ]; then

	if [ -f $TOUCH ]; then
		if [ `find $WATCHDIR -newer $TOUCH -type f | egrep -v "$IGNORE" | tee auto-build.log | wc -l` == 0 ]; then
			if [ $LOOPS -gt $TIMES ]; then
				echo `date --rfc-3339=seconds` still nothing new... `pwd`
				LOOPS=0
			fi
		else
			echo `date --rfc-3339=seconds` "building ($BUILD) because of something new"
			find $WATCHDIR -newer $TOUCH -type f | egrep -v "$IGNORE" | head
			BUILDIT=1
		fi
	else
		echo `date --rfc-3339=seconds` "building ($BUILD) because of no $TOUCH file"
		BUILDIT=1
	fi
	if [ $BUILDIT == 1 ]; then
		$BUILD
		debug "build finished, touch timestamp and sleep..."
		debug "you can pause the build with the command"
		debug "touch $PAUSE"
		cat auto-build.log >> auto-build-all.log
		rm auto-build.log
		touch $TOUCH
		LOOPS=0
	fi

	else
		debug "build paused, you can resume it with the command"
		debug "rm $PAUSE"
		ls -al $PAUSE
		cat $PAUSE
	fi
	sleep $WAIT
	LOOPS=$(( $LOOPS + 1 ))
done
