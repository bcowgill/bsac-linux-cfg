#!/bin/bash
# show the latest few git log messages in all repositories
# as defined by PJ and REPOS environment variables

if [ -z "$PJ" ]; then
	echo NOT OK you must define the PJ environment variable to indicate where your git projects are.
	exit 1
else
	if [ -z "$REPOS" ]; then
		echo NOT OK you must define the REPOS environment variable to indicate which git repository directories to process
		exit 2
	fi
	pushd $PJ
fi

for dir in $REPOS
do
	echo " "
	echo $dir ======================================================
	pushd $dir > /dev/null
		git log $* | head -18
	popd > /dev/null
done
