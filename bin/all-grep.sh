#!/bin/bash
# git grep in all repositories
# as defined by PJ and REPOS environment variables

if [ -z "$PJ" ]; then
	echo NOT OK you must define the PJ environment variable to indicate where your git projects are.
	exit 1
else
	if [ -z "$REPOS" ]; then
		echo NOT OK you must define the REPOS environment variable to indicate which git repository directories to process
		exit 2
	fi
	pushd $PJ
fi

# enable to see how command line modified
if /bin/false; then
	set -x
	/bin/true git grep $*
	set +x
fi

for dir in $REPOS
do
	echo " "
	echo $dir ======================================================
	pushd $dir > /dev/null
		git grep $*
	popd > /dev/null
done
