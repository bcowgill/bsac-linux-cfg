#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# Perform a simple search and replace. Much like sed -i.bak -e 's/Search/Replace/' filename...
# see also srep.sh for more complex version
# WINDEV tool useful on windows development machine

function usage
{
	local message
	message="$1"
	if [ ! -z "$message" ]; then
		echo "$message"
	fi
	echo "
$(basename $0) search replace files...

This wil perform a simple global inplace search and replace in the listed files.

A backup file suffixed with .bak will be created before the replacement takes place.
"
	exit 1;
}

SEARCH="$1"
REPLACE="$2"
shift
shift

if [ -z "$SEARCH" ]; then
	usage "You must provide a non-empty search string."
fi

if [ -z "$1" ]; then
	usage "You must provide a list of file names."
fi

echo Search for [$SEARCH] and replace with [$REPLACE] in files.
SEARCH="$SEARCH" REPLACE="$REPLACE" perl -i.bak -pne '
	s{$ENV{SEARCH}}{$ENV{REPLACE}}xmsg;
' $*

