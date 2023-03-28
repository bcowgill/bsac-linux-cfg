#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# slay a process, gently at first but more forcefully if that doesn't work
# WINDEV tool useful on windows development machine

# requires pswide.sh

WAIT=2
PID=$1
if [ -z "$PID" ]; then
	pswide.sh
	echo "PID to kill? "
	read PID
fi

function slay
{
	local signal pid
	signal=$1
	pid=$2
	ps -p $pid
	kill -0 $pid 2> /dev/null && (echo kill $pid $signal; kill $signal $pid; sleep $WAIT)
}

while [ ! -z "$PID" ]
do
	if [ $PID -lt 1000 ]; then
		echo "PID $PID is too low a number, might be important."
		exit 1
	fi

	if [ ! -z "$PID" ]; then
		slay -HUP $PID
		slay -TERM $PID
		slay -SIGINT $PID
		slay -KILL $PID
	fi

	shift
	PID=$1
done

