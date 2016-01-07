#!/bin/bash
# git grep all repos for git files
pushd ~/projects
DIRS="core-ui files-ui groups-ui dealroom-ui new-ui"

if /bin/false; then
	set -x
	/bin/true git grep $*
	set +x
fi

for dir in $DIRS
do
	echo " "
	echo $dir ======================================================
	pushd $dir > /dev/null
		git grep $*
	popd > /dev/null
done

