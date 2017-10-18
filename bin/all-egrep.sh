#!/bin/bash
# egrep in projects for something filtering out built files

if [ -z "$PJ" ]; then
	echo NOT OK you must define the PJ environment variable to indicate where your git projects are. i.e. $HOME/workspace
	exit 1
else
	pushd $PJ
fi

# enable to see how command line modified
if false; then
	set -x
	true egrep -r $* .
	set +x
fi

egrep -r $* . | filter-built-files.sh

