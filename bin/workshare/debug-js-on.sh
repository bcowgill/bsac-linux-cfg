#!/bin/bash
# debug-js-on.sh turn on debubbing statements marked //dbg:

pushd ~/projects
	FILES=`egrep -rl '/[/]\s*dbg:' | filter-built-files.sh`
	perl -i.bak -pne 's{//\s*dbg:(\s*)}{/*dbg:*/$1}xmsg' $FILES
popd
