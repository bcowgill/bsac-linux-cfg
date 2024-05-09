#!/bin/bash
# Shell script based test plan
# set -e gotchas http://mywiki.wooledge.org/BashFAQ/105
set -e

# What we're testing and sample input data
PROGRAM=../../utf8dbg.pl
CMD=`basename $PROGRAM`
SAMPLE="tschüß TSCHÜSS"
UNNAMED_CHAR=
DEBUG=
SKIP=0
HEAD=3

# Include testing library and make output dir exist
source ../shell-test.sh
PLAN 8

[ -d out ] || mkdir out
rm out/* > /dev/null 2>&1 || OK "output dir ready"

# Do not terminate test plan if out/base comparison fails.
ERROR_STOP=0

# Filter an output file to remove changing text like dates, etc...
function filter {
	local file
	file="$1"
	perl -i -pne '
		s{PV\(0x[0-9a-fA-F]+\) \s at \s 0x[0-9a-fA-F]+}{PV(0xABCD0123) at 0x0123ABCD}xmsg;
		s{PV \s = \s 0x[0-9a-fA-F]+}{PV = 0xABCD0123}xmsg;
	' $file
}

echo TEST $CMD command help
TEST=command-help
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --help $SAMPLE"
	$PROGRAM $ARGS > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful operation
TEST=success
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	ERR=out/$TEST-err.out
	BASE=base/$TEST.base
	BASEERR=base/$TEST-err.base
	ARGS="$DEBUG"
	echo $UNNAMED_CHAR | $PROGRAM $ARGS $UNNAMED_CHAR $SAMPLE > $OUT 2> $ERR || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	filter "$ERR"
	assertFilesEqual "$OUT" "$BASE" "$TEST STDOUT"
	assertFilesEqual "$ERR" "$BASEERR" "$TEST STDERR"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful operation stdin
TEST=success-stdin
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	ERR=out/$TEST-err.out
	BASE=base/$TEST.base
	BASEERR=base/$TEST-err.base
	ARGS="$DEBUG"
	echo $UNNAMED_CHAR | PERL_UNICODE=D $PROGRAM $ARGS > $OUT 2> $ERR || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	filter "$ERR"
	assertFilesEqual "$OUT" "$BASE" "$TEST STDOUT"
	assertFilesEqual "$ERR" "$BASEERR" "$TEST STDERR"
else
	echo SKIP $TEST "$SKIP"
fi

cleanUpAfterTests
