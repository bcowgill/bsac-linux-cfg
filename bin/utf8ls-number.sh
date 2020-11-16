#!/bin/bash
# WINDEV tool useful on windows development machine

TABLE=${TABLE:-}

if [ -z "$2" ]; then
	echo "
$(basename $0) digit number [of]

This will list all unicode numbers related to the named one provided.

It looks for /NUMBER|DIGIT number of/ in the unicode name string.

Specify TABLE=1 in environment to output a perl key value table.

ex.

$(basename $0) 1 one of
"
	exit 0
fi
D=$1
L=$2

if [ -z $TABLE ]; then
	grep-utf8.sh \(NUMBER\|DIGIT\) $L\\b $3 \
		| grep -vE HUNDRED\|THOUSAND\|FRACTION\|COMMA\|FULL\ STOP
else
	grep-utf8.sh \(NUMBER\|DIGIT\) $L\\b $3 \
		| grep -vE HUNDRED\|THOUSAND\|FRACTION\|COMMA\|FULL\ STOP \
		| L=$D perl -pne 's{\s+.+\z}{$1 }xms; BEGIN { print qq{\t$ENV{L} => [qw( } } END { print qq{)],\n}}'
fi
