#!/bin/bash
# egrep in projects for a spaced string filtering out built files
# use ESOPTS environment var to specify other grep options like -l -L
# WINDEV tool useful on windows development machine

if [ -z "$PJ" ]; then
	echo NOT OK you must define the PJ environment variable to indicate where your git projects are. i.e. $HOME/workspace
	exit 1
else
	pushd $PJ
fi

# enable to see how command line modified
if false; then
	set -x
	true egrep -r $ESOPTS "$*" .
	set +x
fi

egrep -r $ESOPTS "$*" . | filter-built-files.sh

