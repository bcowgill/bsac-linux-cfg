#!/bin/bash
# fetch a branch in all git repositories
# as defined by PJ and REPOS environment variables
# WINDEV tool useful on windows development machine

BRANCH=$1
if [ -z "$BRANCH" ]; then
	echo NOT OK you need to specify a branch name to checkout
fi

all-repos.sh git checkout $BRANCH
