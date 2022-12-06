#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?]

This will read lines from standard input and output them in reverse order.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

See also random-order.sh, choose.pl, cp-random.pl, random-ringtone.sh, randomize-urls.sh, random-text.sh, random-desktop.sh

Examples:

Reverse the order of a sorted directory listing (inefficient, just an example)

  ls | sort -f | $cmd
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

perl -ne 'chomp; push(@Lines, $_); END { my $lines = scalar(@Lines) - 1; for (my $idx = $lines; $idx >= 0; --$idx) { print qq{$Lines[$idx]\n}} }'
