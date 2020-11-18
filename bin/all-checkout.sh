#!/bin/bash
# WINDEV tool useful on windows development machine

function usage {
	local code
	code=$1
	echo "
$(basename $0) [--help|--man|-?] checkout

This will do a checkout from all git repositories as defined by PJ and REPOS environment variables.

PJ       where your git projects are. i.e. $HOME/workspace
REPOS    which git repository directories to process.
checkout file or other checkout options to perform in each repository.
--man    Shows help for this tool.
--help   Shows help for this tool.
-?       Shows help for this tool.

The program will change to the PJ directory then loop through the REPOS defined, changing into those directories and issuing the git checkout there.

See also all-repos.sh, all-clean.sh, all-grep.sh, all-push.sh, and others.

Example:

	to restore the package.json from git in all repositories.

	$(basename $0) -- package.json

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
		git checkout $*
	popd > /dev/null
done
