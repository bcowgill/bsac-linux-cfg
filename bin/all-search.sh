#!/bin/bash
# git grep for a fixed string in all repositories
# as defined by PJ and REPOS environment variables
# i.e. all-search.sh this string will be quoted

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

# enable to see how command line modified
if false; then
	set -x
	true git grep "$*"
	set +x
fi

for dir in $REPOS
do
	echo " "
	echo $dir ======================================================
	pushd $dir > /dev/null
		git grep "$*"
	popd > /dev/null
done
