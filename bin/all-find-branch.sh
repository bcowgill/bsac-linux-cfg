#!/bin/bash
# grep for a branch in all git repositories
# as defined by PJ and REPOS environment variables
# WINDEV tool useful on windows development machine

BRANCH=$1
if [ -z "$BRANCH" ]; then
	echo NOT OK you must specify a part of a branch name to search for
	exit 1
fi

all-repos.sh git branch --list --remote | egrep "=======|$BRANCH"
