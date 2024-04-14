#!/bin/bash

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "$cmd [--help|--man|-?] shell-script-name...

This will list all the external possibly unavailable commands or functions used in a shell script.

shell-script-name  The script command file to examine for external dependencies.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.
"
	exit $code
}
if [ "$1" == "--help" ]; then
	usage 0
fi
if [ "$1" == "--man" ]; then
	usage 0
fi
if [ "$1" == "-?" ]; then
	usage 0
fi
if echo "$*" | grep -- '--' > /dev/null; then
	usage 1
fi

LIST=`mktemp`
FILES="$*"
grep -viE '^\s*(\#|[a-z_-]+\s*=)' $FILES \
	| perl -ne 's{(^|;|`|\$\{\||\(|&&|\|\|)\s*([a-z/]+[a-z0-9/._-]*)}{print "$2\n"}xmsge' \
	| grep -vE '\b(cat|date|df|do|done|du|echo|else|exit|export|fi|file|find|for|function|grep|head|if|local|ls|man|mkdir|mv|perl|pwd|rm|rmdir|shift|sleep|source|tail|tar|tee|then|touch|trap|usage|which|while|chomp|die|elsif|my|print|return|sub)\b' \
	| sort | uniq > $LIST

for cmd in `cat "$LIST"`; do grep -E "^\s*((function|sub)\s+$cmd\b|$cmd\s*\(\))" $FILES > /dev/null || echo $cmd; done

rm "$LIST"
