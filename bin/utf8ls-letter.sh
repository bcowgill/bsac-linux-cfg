#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

TABLE=${TABLE:-}

if [ -z "$1" ]; then
	echo "
$(basename $0) letter [with]

This will list all unicode letters related to the one provided.

It looks for /SMALL|CAPITAL LETTER letter with/ in the unicode name string.

Specify TABLE=1 in environment to output a perl key value table.

See also anglicise.pl, utf8tr.pl, math-rep.pl, utf8-ellipsis.pl, utf8-filter.pl, utf8ls-letter.sh, utf8ls-number.sh, utf8ls.pl
ex.

$(basename $0) A with

"
	exit 0
fi
l=`perl -e "print lc(qq{$1})"`
L=`perl -e "print uc(qq{$1})"`

if [ -z $TABLE ]; then
	grep-utf8.sh SMALL LETTER $L\\b $2
	grep-utf8.sh CAPITAL LETTER $L\\b $2
else
	grep-utf8.sh SMALL LETTER $L\\b $2 \
		| L=$l perl -pne 's{\s+.+\z}{$1 }xms; BEGIN { print qq{\t$ENV{L} => [qw( } } END { print qq{)],\n}}'
	grep-utf8.sh CAPITAL LETTER $L\\b $2 \
		| L=$L perl -pne 's{\s+.+\z}{$1 }xms; BEGIN { print qq{\t$ENV{L} => [qw( } } END { print qq{)],\n}}'
fi
