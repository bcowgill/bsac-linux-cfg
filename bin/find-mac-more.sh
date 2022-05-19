#!/bin/bash
# find in your Mac $HOME dir ignoring Applications and Library dirs.
if [ -z "$1" ]; then
	GO="-print"
fi
pushd ~ > /dev/null
find . -path ./Library -prune -o -path ./Applications -prune -o ${GO:-$@}
popd > /dev/null
