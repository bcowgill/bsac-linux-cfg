#!/bin/bash
# Shell script based test plan
# set -e gotchas http://mywiki.wooledge.org/BashFAQ/105
set -e

# What we're testing and sample input data
PROGRAM=../../template/perl/perl-lite.pl
CMD=`basename $PROGRAM`
SAMPLE=in/sample.txt
DEBUG=--debug
DEBUG=
SKIP=0
MANDATORY="--length=42 --hex=0x3c7e --file=filename --name=name --map key=value"


# Include testing library and make output dir exist
source ../shell-test.sh
PLAN 4

[ -d out ] || mkdir out
rm out/* > /dev/null 2>&1 || OK "output dir ready"

# Do not terminate test plan if out/base comparison fails.
ERROR_STOP=0

function clean_path {
	local output
	output="$1"
	perl -i -pne 's{(my \s+ script \s+ is: \s+).+?(template/perl)}{$1PWD/$2}xms' "$output"
}

echo TEST $CMD usage
TEST=usage
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	NO_UNIT_TESTS=1 $PROGRAM $ARGS > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

cleanUpAfterTests
