#!/bin/bash
# find-ez easy find shows just name, size and time

find-ez () {
	local sourceDir
	sourceDir="$1"
	pushd "$sourceDir" > /dev/null && find . -type f -printf '"%h/%f"\t%s\t%T+\n' && popd > /dev/null
}

find-ez "$1"
