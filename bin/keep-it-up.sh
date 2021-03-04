#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# poor man's runit - keeps re-running a command when it dies.
# WINDEV tool useful on windows development machine

if [ -z "$1" ]; then
	RUN='npm start'
else
	RUN="$*"
fi
DELAY=${2:-2}

while  [ true ]
do
	echo Press ^C to stop keeping it up [ $RUN ]
	sleep $DELAY
	$RUN
	echo Exit $? from [ $RUN ]
done
