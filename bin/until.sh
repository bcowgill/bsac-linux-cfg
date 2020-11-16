#!/bin/bash
# WINDEV tool useful on windows development machine
if [ -z "$1" ]; then
	echo "
$(basename $0) regex-end

This will show everything from standard input until a line matches the regular expression given.

The regular expression syntax used is perl's xms syntax.  Note, you MUST escape spaces in this format (\s or \ )

Also note that \A signifies start of line and \z signifies end of line in this format.

See also after.sh middle.sh inject-middle.sh between.sh prepend.sh
"
	exit 1
fi
REGEX="$1" perl -ne 'print unless $stop; $stop = $stop || m{$ENV{REGEX}}xms'
