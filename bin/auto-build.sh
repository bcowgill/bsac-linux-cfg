#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# auto rebuild when things change
# CUSTOM settings you may need to change on a new computer
TOUCH=last-build.timestamp
PAUSE=`pwd`/pause-build.timestamp
WATCHDIR=..
WAIT=6
TIMES=50
LOOPS=0
IGNORE='/\.tmp/|/\.git/|/\.idea/|/dist/|/coverage/|/node_modules/|/bower_components/|\.log$|\.timestamp$|\.swp$|\.bak$|~$|\.\#.*$|\#.+\#$|\.orig$|\.kate-swp$|\.yml$|/public/doc/'
DEBUG=1
DATE=date
if which datestamp.sh > /dev/null; then
	DATE=datestamp.sh
fi

function usage
{
	echo "
usage: $(basename $0) build-command [watch-dir]

You must supply a build command to run.

This will run the given build command every time a file changes in the watch-dir specified (defaults to the parent directory.)
"
	exit 1
}

if [ -z "$1" ]; then
	usage
fi
if [ "$1" == "--help" ]; then
	usage
fi
if [ "$1" == "--man" ]; then
	usage
fi
if [ "$1" == "-?" ]; then
	usage
fi
BUILD="$1"
if [ ! -z "$2" ]; then
	shift
	WATCHDIR="$*"
fi
echo BUILD=$BUILD
echo WATCHDIR="$WATCHDIR"
echo TOUCH=$TOUCH
echo PAUSE=$PAUSE
echo IGNORE="$IGNORE"
$DATE

function debug
{
	local message
	message=$1
	if [ ${DEBUG:-0} == 1 ]; then
		echo $message
	fi
}

while  [ true ]
do
	BUILDIT=0
	if [ ! -f "$PAUSE" ]; then

	if [ -f $TOUCH ]; then
		if [ `find $WATCHDIR -newer $TOUCH -type f | egrep -v "$IGNORE" | tee auto-build.log | wc -l` == 0 ]; then
			if [ $LOOPS -gt $TIMES ]; then
				echo `$DATE` still nothing new... `pwd`
				LOOPS=0
			fi
		else
			echo `$DATE` "building ($BUILD) because of something new"
			find $WATCHDIR -newer $TOUCH -type f | egrep -v "$IGNORE" | head
			BUILDIT=1
		fi
	else
		echo `$DATE` "building ($BUILD) because of no $TOUCH file"
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
