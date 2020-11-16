#!/bin/bash
# WINDEV tool useful on windows development machine
export START=$1
shift
export END=$1
shift

if [ -z "$1" ]; then
	cat <<EOF
usage: $(basename $0) start end file ...

This script will grep a file for a section marked by an open and close marker and display the content found.

See also after.sh inject-middle.sh, between.sh, prepend.sh, until.sh

example:

$(basename $0) '#WORKSPACEDEF' '#/WORKSPACEDEF' filename
EOF
	exit 1
fi

#echo $START to $END
#echo $*

perl -ne '
if (m{$ENV{START}}) { $print = 1; };
print if $print;
if (m{$ENV{END}}) {$print = 0; };
' $*
