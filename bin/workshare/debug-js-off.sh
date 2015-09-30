#!/bin/bash
# debug-js-off.sh turn off debugging statements marked /*dbg:*/
# by replacing them with //dbg:

DIR=${1:-~/projects}

pushd $DIR > /dev/null
	FILES=`git grep -lE '/\*\s*dbg:' 2> /dev/null || egrep -rl '/\*\s*dbg:'`
	perl -i.bak -pne 's{/\* \s* dbg: \s* \*\/(\s*)}{//dbg:$1}xmsg' $FILES
popd > /dev/null
