#!/bin/bash
# Shell script based test plan
# set -e gotchas http://mywiki.wooledge.org/BashFAQ/105
set -e

# What we're testing and sample input data
SUITE=common
PROGRAM=../../json-$SUITE.pl
CMD=`basename $PROGRAM`
SAMPLE=in/chinese1.json
SAMPLE2=in/chinese2.json
EMPTY1=in/empty.json
EMPTY2=in/empty-oneline.json
DEBUG=
SKIP=0

# Include testing library and make output dir exist
source ../shell-test.sh
PLAN 20

[ -d out ] || mkdir out
rm out/* > /dev/null 2>&1 || OK "output dir ready"

# Do not terminate test plan if out/base comparison fails.
ERROR_STOP=0

echo TEST $CMD command help
TEST=$SUITE-command-help
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

echo TEST $CMD command invalid file
TEST=$SUITE-command-invalid
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=1
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --invalid --$SAMPLE"
	$PROGRAM $ARGS > $OUT 2>&1 || ERR=$?
	assertCommandFails $ERR $EXPECT "$PROGARM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD success with empty json
TEST=$SUITE-success-empty
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	WARN=out/$TEST.warn.out
	BASE=base/$TEST.base
	BASEWARN=base/$TEST.warn.base
	ARGS="$DEBUG"
	$PROGRAM $ARGS $EMPTY1 $EMPTY1 2> $WARN > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$WARN" "$BASEWARN" "$TEST stderr output"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD success with oneline empty json
TEST=$SUITE-success-empty-oneline
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	WARN=out/$TEST.warn.out
	BASE=base/$TEST.base
	BASEWARN=base/$TEST.warn.base
	ARGS="$DEBUG"
	$PROGRAM $ARGS $EMPTY2 $EMPTY2 2> $WARN > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$WARN" "$BASEWARN" "$TEST stderr output"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful operation
TEST=$SUITE-success
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	WARN=out/$TEST.warn.out
	BASE=base/$TEST.base
	BASEWARN=base/$TEST.warn.base
	ARGS="$DEBUG"
	$PROGRAM $ARGS $SAMPLE $SAMPLE2 2> $WARN > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$WARN" "$BASEWARN" "$TEST stderr output"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful reverse operation
TEST=$SUITE-success-reverse
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	WARN=out/$TEST.warn.out
	BASE=base/$TEST.base
	BASEWARN=base/$TEST.warn.base
	ARGS="$DEBUG"
	$PROGRAM $ARGS $SAMPLE2 $SAMPLE 2> $WARN > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$WARN" "$BASEWARN" "$TEST stderr output"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful operation all same
TEST=$SUITE-success-all-same
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	WARN=out/$TEST.warn.out
	BASE=base/$TEST.base
	BASEWARN=base/$TEST.warn.base
	ARGS="$DEBUG"
	$PROGRAM $ARGS $SAMPLE $SAMPLE 2> $WARN > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$WARN" "$BASEWARN" "$TEST stderr output"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful operation empty no commons
TEST=$SUITE-success-empty-no-commons
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	WARN=out/$TEST.warn.out
	BASE=base/$TEST.base
	BASEWARN=base/$TEST.warn.base
	ARGS="$DEBUG"
	$PROGRAM $ARGS $EMPTY2 $SAMPLE2 2> $WARN > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$WARN" "$BASEWARN" "$TEST stderr output"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful operation nothing common
TEST=$SUITE-success-no-commons
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	WARN=out/$TEST.warn.out
	BASE=base/$TEST.base
	BASEWARN=base/$TEST.warn.base
	ARGS="$DEBUG"
	$PROGRAM $ARGS $SAMPLE2 $EMPTY2 2> $WARN > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$WARN" "$BASEWARN" "$TEST stderr output"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

cleanUpAfterTests
