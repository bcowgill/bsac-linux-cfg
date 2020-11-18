#!/bin/bash
# WINDEV tool useful on windows development machine

function usage {
	local code
	code=$1
	echo "
$(basename $0) [--help|--man|-?] branch

This will grep for a branch in all git repositories as defined by PJ and REPOS environment variables.

PJ      where your git projects are. i.e. $HOME/workspace
REPOS   which git repository directories to process.
branch  The branch or partial branch name you wish search for in each repository.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

The program will change to the PJ directory then loop through the REPOS defined, changing into those directories and issuing a search for remote branches there.

See also all-repos.sh, all-clean.sh, all-checkout.sh, all-grep.sh, all-push.sh, and others.
"
	exit $code
}
if [ "$1" == "--help" ]; then
	usage 0
fi
if [ "$1" == "--man" ]; then
	usage 0
fi
if [ "$1" == "-?" ]; then
	usage 0
fi

BRANCH=$1
if [ -z "$BRANCH" ]; then
	echo NOT OK you must specify a part of a branch name to search for
	exit 1
fi

all-repos.sh git branch --list --remote | egrep "=======|$BRANCH"
