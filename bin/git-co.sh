#!/bin/bash

SEARCH="$1"

if [ -z "$SEARCH" ]; then
	echo "
usage: $(basename $0) search

This program will git checkout the single branch which matches the search pattern specified.

If more than one branch matches the pattern then they are shown and nothing else happens.

If there are only two matches and you are currently on one of them you will switch to the other one.
"
	exit 1
fi


if [ `git branch --list | grep -v '*' | grep -i "$SEARCH" | wc -l` == "1" ]; then
	BRANCH=`git branch --list | grep -v '*' | grep -i "$SEARCH"`
	git checkout $BRANCH
else
	git branch --list | grep -i "$SEARCH" | sort
fi
