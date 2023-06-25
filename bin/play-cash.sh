#!/bin/bash
# Play a random cash register or money song whenever a file is saved in the money directory.
# Does not work well from cron table:
# * * * * *                  $HOME/bin/play-cash.sh "" > /tmp/$LOGNAME/crontab-play-cash.log  2>&1
# Instead created gnucash.sh to launch gnucash and run play-cash.sh together which works well.

DEBUG=
CMD=`basename $0`

MONEY_DIR=${1:-$HOME/d/docs/money}
CASH_SOUNDS=${2:-$HOME/d/Music/money-cash-register}

TIMESTAMP="$MONEY_DIR/timestamp.dat"
LOCKED="$MONEY_DIR/play-cash.locked"
SOUNDS=`mktemp`

function get_sounds
{
	if [ -d "$CASH_SOUNDS" ]; then
		find "$CASH_SOUNDS" -type f | filter-music > $SOUNDS
	else
		locate --regex -i 'money|cash' | filter-music | grep -ivE '/(podcasts|_spoken|ayn-rand|history-of-philosophy)/|johnny cash' > $SOUNDS
	fi
	if [ ! -z "$DEBUG" ]; then
		echo Money sound files found:
		cat $SOUNDS
	fi
}

function gnucash_is_not_running
{
	[ 0 == `ps -ef | grep gnucash | grep -vE 'grep|gnucash\.sh' | wc -l` ]
}

function play_cash_sound
{
	SOUND="`choose.pl 1 $SOUNDS`"
	echo will play SOUND=$SOUND
	sound-play.sh "$SOUND"
}

function unlock
{
	rmdir "$LOCKED" > /dev/null
}

function cleanup
{
	if [ -z "$DEBUG" ]; then
		rm $SOUNDS
	fi
	unlock
	exit $1
}

# An error handler to trap premature terminations.
# source: http://stackoverflow.com/questions/64786/error-handling-in-bash
function error()
{
	local parent_lineno="$1"
	local message="$2"
	local code="${3:-1}"
	echo "$CMD: terminated by error while in `pwd`"
	if [[ -n "$message" ]] ; then
		echo "on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
	else
		echo "on or near line ${parent_lineno}; exiting with status ${code}"
	fi
	unlock
	exit "${code}"
}

mkdir -p "$MONEY_DIR" 2> /dev/null
if mkdir "$LOCKED" 2> /dev/null; then
	if [ ! -z "$DEBUG" ]; then
		echo $LOCKED created, we will run...
	fi
	# on error or ^C during script, unlock
	trap 'error ${LINENO}' ERR
	trap 'cleanup' HUP
	trap 'cleanup' INT
else
	if [ ! -z "$DEBUG" ]; then
		echo $MONEY_DIR locked: we are already running, exiting...
	fi
	exit 1
fi

if gnucash_is_not_running ; then
	if [ ! -z "$DEBUG" ]; then
		echo gnucash is not running, play one sound and then exit.
		get_sounds
		play_cash_sound
		cleanup 0
	else
		unlock
		exit 0
	fi
else
	echo gnucash is running, will monitor "$MONEY_DIR" for changed files and play random money sounds...
	get_sounds
	touch "$TIMESTAMP"
fi

while /bin/true
do
	sleep 5
	if [ 0 != `find "$MONEY_DIR" -type f -newer "$TIMESTAMP" | wc -l` ]; then
		if [ ! -z "$DEBUG" ]; then
			echo File was touched... `find "$MONEY_DIR" -newer "$TIMESTAMP"`
		fi
		play_cash_sound
		touch "$TIMESTAMP"
	fi
	if gnucash_is_not_running ; then
		echo gnucash is not running, exiting...
		cleanup 0
	fi
done

# TODO ^C handler to remove temp file
