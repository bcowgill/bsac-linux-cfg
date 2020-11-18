#!/bin/bash
# WINDEV tool useful on windows development machine

function usage {
	local code
	code=$1
	echo "
$(basename $0) [--help|--man|-?] options

This will show the latest few git log messages in all git repositories as defined by PJ and REPOS environment variables.

PJ      where your git projects are. i.e. $HOME/workspace
REPOS   which git repository directories to process.
options git log command options for each repository.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

The program will change to the PJ directory then loop through the REPOS defined, changing into those directories and issuing the git log there.

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
		git log $* | head -18
	popd > /dev/null
done
