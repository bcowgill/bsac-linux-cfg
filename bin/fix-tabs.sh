#!/bin/bash

function usage {
	local message code
	message="$1"
	code=0
	if [ ! -z "$message" ]; then
		code=1
		echo $message
		echo -n
	fi
	echo "
usage: $(basename $0) from-tab to-tab file_name

This will change a files spaced indentation for example from 4 spaces to 2 spaces.

from-tab  number of spaces the file is currently indented per tab.
to-tab    desired number of spaces to indent per tab.
file_name the file whose indentation needs correction.
"
	exit $code
}

FROM="$1"
TO=i"$2"
FILE="$3"

if [ -z "$FROM" ]; then
	usage
fi

if [ -z "$TO" ]; then
	usage "You must provide the desired number of spaces for tab indentation."
fi

if [ -z "$FILE" ]; then
	usage "You must provide the name of a file to have space indentation corrected within."
fi

INDENT_TAB=1 INPLACE=1 INDENT=$FROM fix-spaces.sh "$FILE"
INDENT_TAB=0 INPLACE=1 INDENT=$TO   fix-spaces.sh "$FILE"

