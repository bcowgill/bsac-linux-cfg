#!/bin/bash
# egrep all repos for something filtering out built files
pushd ~/projects

if /bin/false; then
	set -x
	/bin/true egrep -r $* .
	set +x
fi

egrep -r $* . | filter-built-files.sh

