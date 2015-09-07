#!/bin/bash
set -e

TOP=~/projects
FULL_REBUILD=0
ENV="--cirrus-env=dev3"
#ENV=""
PROJECTS="core-ui files-ui groups-ui dealroom-ui"
JSHINT="$PROJECTS new-ui"

killall grunt || echo carry on

pushd $TOP > /dev/null
if [ ${FULL_REBUILD:-0} == 1 ] ; then
	for dir in $JSHINT
	do
		pushd $dir > /dev/null
		echo in $dir ===================================================
		npm install
		bower install
		popd > /dev/null
	done
fi

for dir in $JSHINT
do
	pushd $dir > /dev/null
	echo in $dir ===================================================
	grunt jshint
	popd > /dev/null
done

for dir in $JSHINT
do
	pushd $dir > /dev/null
	echo in $dir ===================================================
	grunt build
	popd > /dev/null
done

dir=new-ui
pushd $dir > /dev/null
echo in $dir ===================================================
grunt serve $ENV
popd > /dev/null

popd > /dev/null
