#!/bin/bash
# debug-js-off.sh turn off debugging statements marked /*dbg:*/
# by replacing them with //dbg:
# See also activate.sh, deactivate.sh, debug-js-on.sh
# WINDEV tool useful on windows development machine

# CUSTOM settings you may have to change on a new computer

DIR=${1:-~/projects}

pushd $DIR > /dev/null
	FILES=`(git grep -lE '/\*\s*dbg:' 2> /dev/null || egrep -rl '/\*\s*dbg:') | egrep -v \.bak\$`
	perl -i.bak -pne 's{/\* \s* dbg: \s* \*\/(\s*)}{//dbg:$1}xmsg' $FILES
popd > /dev/null
