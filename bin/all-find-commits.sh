#!/bin/bash
# grep for a commit message in all git repositories
# as defined by PJ and REPOS environment variables

COMMIT=$1
if [ -z "$COMMIT" ]; then
	echo NOT OK you must specify a part of a commit name to search for
	exit 1
fi

for dir in $REPOS
do
	echo " "
	echo $dir ======================================================
	pushd $dir > /dev/null
		git log | grep $COMMIT -B 4 -A 3
	popd > /dev/null
done
