#!/bin/bash
# slay a process, gently at first but more forcefully if that doesn't work

PID=$1
WAIT=2
if [ -z "$PID" ]; then
	pswide.sh
	echo "PID to kill? "
	read PID
fi

if [ $PID -lt 1000 ]; then
	echo "PID $PID is too low a number, might be important."
	exit 1
fi

function slay
{
	local signal pid
	signal=$1
	pid=$2
	kill -0 $pid 2> /dev/null && (echo kill $pid $signal; kill $signal $pid; sleep $WAIT)
}

if [ ! -z "$PID" ]; then
	slay -HUP $PID
	slay -TERM $PID
	slay -SIGINT $PID
	slay -KILL $PID
fi


