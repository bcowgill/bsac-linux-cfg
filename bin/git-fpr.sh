#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

SEARCH="$1"

if [ -z "$SEARCH" ]; then
	echo "
usage: $(basename $0) search

This program will git fetch a pull request branch which matches the search pattern specified.

If more than one remote branch matches the pattern then they are shown and nothing else happens.

This will perform a pull and hard reset to the remote branch.
"
	exit 1
fi


if [ `git branch --list --remote | grep -v '*' | grep -i "$SEARCH" | wc -l` == "1" ]; then
	BRANCH=`git branch --list --remote | grep -v '*' | grep -i "$SEARCH"`
	git-fetch-pull-request.sh $BRANCH
else
	git branch --list --remote | grep -i "$SEARCH" | sort
fi
