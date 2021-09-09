#!/bin/bash
# Shell script based test plan
# set -e gotchas http://mywiki.wooledge.org/BashFAQ/105
set -e

# What we're testing and sample input data
PROGRAM=../../json-minus.pl
CMD=`basename $PROGRAM`
SAMPLE=in/chinese1.json
SAMPLE2=in/chinese2.json
EMPTY1=in/empty.json
EMPTY2=in/empty-oneline.json
DEBUG=
SKIP=0

# Include testing library and make output dir exist
source ../shell-test.sh
PLAN 42

[ -d out ] || mkdir out
rm out/* > /dev/null 2>&1 || OK "output dir ready"

# Do not terminate test plan if out/base comparison fails.
ERROR_STOP=0

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

SKIP=1
echo TEST $CMD command invalid option
TEST=command-invalid
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=1
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --invalid $SAMPLE"
	$PROGRAM $ARGS > $OUT 2>&1 || ERR=$?
	assertCommandFails $ERR $EXPECT "$PROGARM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD command incompatible options
TEST=command-invalid-options
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=1
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --inplace --keep $SAMPLE"
	$PROGRAM $ARGS 2>&1 | head -3 > $OUT
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD command inplace and show are incompatible
TEST=command-invalid-inplace-show
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=1
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --inplace --show $SAMPLE"
	$PROGRAM $ARGS 2>&1 | head -3 > $OUT
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

SKIP=0

echo TEST $CMD success with empty json
TEST=success-empty
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
TEST=success-empty-oneline
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
TEST=success
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
TEST=success-reverse
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

echo TEST $CMD successful operation all dups
TEST=success-all-dups
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

echo TEST $CMD successful operation nothing removed
TEST=success-nothing-removed
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

echo TEST $CMD successful operation nothing output
TEST=success-nothing-output
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
