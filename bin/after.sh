#!/bin/bash
# WINDEV tool useful on windows development machine
if [ -z "$1" ]; then
	echo "
$(basename $0) regex-start

This will show everything from standard input starting from the line that matches the regular expression given.

The regular expression syntax used is perl's xms syntax.  Note, you MUST escape spaces in this format (\s or \ )

Also note that \A signifies start of line and \z signifies end of line in this format.

See also prepend.sh, middle.sh, inject-middle.sh, between.sh, until.sh
"
	exit 1
fi
REGEX="$1" perl -ne '$start = $start || m{$ENV{REGEX}}xms; print if $start'
