#!/bin/bash
# find in your Mac $HOME dir ignoring Applications Library and some other dirs.
if [ -z "$1" ]; then
	GO="-print"
fi
pushd ~ > /dev/null
find . -path ./Library -prune -o -path ./Applications -prune -o -name .git -prune -o -name node_modules -prune -o ${GO:-$@}
popd > /dev/null
