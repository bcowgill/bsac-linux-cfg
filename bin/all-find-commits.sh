#!/bin/bash
# grep for a commit message in all git repositories
# as defined by PJ and REPOS environment variables
# WINDEV tool useful on windows development machine

COMMIT=$1
if [ -z "$COMMIT" ]; then
	echo NOT OK you must specify a part of a commit name to search for
	exit 1
fi

if [ -z "$PJ" ]; then
	echo NOT OK you must define the PJ environment variable to indicate where your git projects are. i.e. $HOME/workspace
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
		git log | grep $COMMIT -B 4 -A 3
	popd > /dev/null
done
