#!/bin/bash
pushd ~/projects
DIRS="core-ui files-ui groups-ui dealroom-ui new-ui"

for dir in $DIRS
do
	echo " "
	echo $dir ======================================================
	pushd $dir > /dev/null
		git log $* | head -10
	popd > /dev/null
done
