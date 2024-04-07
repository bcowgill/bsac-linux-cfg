#!/bin/bash
# Scan the playwright tests for leftover debugging or other problems.

DIR=

git grep -E '\.(pause|only)\(' $DIR | grep -E '\.[jt]s:' | grep -vE '_channel\.pause|\.[jt]s:\s*//' > scan.log

ICON="⋅❌ "
COUNT=`wc -l < scan.log | perl -pne 's{\s+}{}xmsg'`
#echo counted: /$COUNT/
if [ "$COUNT" != "0" ]; then
	echo " "
	echo "$ICON ERROR DEBUG statements leftover."
	cat scan.log
	echo " "
	echo 'You have leftover .only( or pause() statements in your tests, make sure you remove them before pushing changes.' 1>&2
	exit 1
fi
