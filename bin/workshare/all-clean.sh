#!/bin/bash
# run clean.sh in all repos
pushd ~/projects
DIRS="core-ui files-ui groups-ui dealroom-ui new-ui"

for dir in $DIRS
do
	echo " "
	echo $dir ======================================================
	pushd $dir > /dev/null
		clean.sh
	popd > /dev/null
done

