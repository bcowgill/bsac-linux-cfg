#!/bin/bash
if [ -z "$1" ]; then
	echo "
$(basename $0) regex-start regex-end

This will show everything from standard input starting from the line which matches the starting regular expression until the line which matches the ending regular expression.

The regular expression syntax used is perl's xms syntax.  Note, you MUST escape spaces in this format (\s or \ )

Also note that \A signifies start of line and \z signifies end of line in this format.
"
	exit 1
fi
START="$1" END="$2" perl -ne '
	$start = $start || m{$ENV{START}}xms;
	print if $start && !$stop;
	$stop = $start && ($stop || m{$ENV{END}}xms);
	last if $stop;
'
