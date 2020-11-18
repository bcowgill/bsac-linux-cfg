#!/bin/bash
# WINDEV tool useful on windows development machine

function usage {
	local code
	code=$1
	echo "
$(basename $0) [--help|--man|-?] message for stash

This will stash your local changes in all git repositories as defined by PJ and REPOS environment variables.

PJ      where your git projects are. i.e. $HOME/workspace
REPOS   which git repository directories to process.
message a description to add to the stash.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

The program will change to the PJ directory then loop through the REPOS defined, changing into those directories and issuing the git stash save there.

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

pushd ~/projects
DIRS="core-ui files-ui groups-ui dealroom-ui new-ui"

for dir in $DIRS
do
	echo " "
	echo $dir ======================================================
	pushd $dir > /dev/null
		git stash save $*
	popd > /dev/null
done
