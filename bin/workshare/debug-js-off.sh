#!/bin/bash
# debug-js-off.sh turn off debubbing statements marked /*dbg:*/
# by replacing them with //dbg:

pushd ~/projects
	FILES=`egrep -rl '/\*\s*dbg:' | filter-built-files.sh`
	perl -i.bak -pne 's{/\* \s* dbg: \s* \*\/(\s*)}{//dbg:$1}xmsg' $FILES
popd
