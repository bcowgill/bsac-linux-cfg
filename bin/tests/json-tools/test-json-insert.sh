#!/bin/bash
# Shell script based test plan
# set -e gotchas http://mywiki.wooledge.org/BashFAQ/105
set -e

# What we're testing and sample input data
SUITE=insert
PROGRAM=../../json-$SUITE.sh
CMD=`basename $PROGRAM`
SAMPLE=in/chinese1.json
SAMPLE2=in/chinese2.json
DUPLICATE=in/duplicate.json
EMPTY1=in/empty.json
EMPTY2=in/empty-oneline.json
DEBUG=
SKIP=0

# Include testing library and make output dir exist
source ../shell-test.sh
PLAN 18

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
	ARGS="$DEBUG --invalid-key --invalid --value not$SAMPLE"
	$PROGRAM $ARGS > $OUT 2>&1 || ERR=$?
	assertCommandFails $ERR $EXPECT "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD duplicate-warning
TEST=$SUITE-warning-duplicate
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	WARN=out/$TEST.warn.out
	BASE=base/$TEST.base
	BASEWARN=base/$TEST.warn.base
	ARGS="$DEBUG file newKey new-value-to-add"
	cp $DUPLICATE $OUT
	$PROGRAM $ARGS $OUT > $WARN 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$WARN" "$BASEWARN" "$TEST stderr output"
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
	ARGS="$DEBUG findKey newKey new-value-to-add"
	cp $EMPTY1 $OUT
	$PROGRAM $ARGS $OUT > $WARN 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$WARN" "$BASEWARN" "$TEST stderr output"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD success with oneline empty json empty value
TEST=$SUITE-success-empty-oneline
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	WARN=out/$TEST.warn.out
	BASE=base/$TEST.base
	BASEWARN=base/$TEST.warn.base
	ARGS="$DEBUG findKey newKey"
	cp $EMPTY2 $OUT
	$PROGRAM $ARGS $OUT > $WARN 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$WARN" "$BASEWARN" "$TEST stderr output"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful operation insert end
TEST=$SUITE-success
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	WARN=out/$TEST.warn.out
	BASE=base/$TEST.base
	BASEWARN=base/$TEST.warn.base
	ARGS="$DEBUG findKey newKey new-value-to-add"
	cp $SAMPLE $OUT
	$PROGRAM $ARGS $OUT > $WARN 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$WARN" "$BASEWARN" "$TEST stderr output"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful operation insert first
TEST=$SUITE-success-insert-first
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	WARN=out/$TEST.warn.out
	BASE=base/$TEST.base
	BASEWARN=base/$TEST.warn.base
	ARGS="$DEBUG file newKey new-value-to-add"
	cp $SAMPLE $OUT
	$PROGRAM $ARGS $OUT > $WARN 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$WARN" "$BASEWARN" "$TEST stderr output"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful operation insert middle
TEST=$SUITE-success-insert-middle
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	WARN=out/$TEST.warn.out
	BASE=base/$TEST.base
	BASEWARN=base/$TEST.warn.base
	ARGS="$DEBUG extra1 newKey new-value-to-add"
	cp $SAMPLE $OUT
#	echo IN=$SAMPLE
#	echo OUT=$OUT
#	echo cp \$IN \$OUT\; DEBUG=1 $PROGRAM $ARGS \$OUT \; cat \$OUT
	$PROGRAM $ARGS $OUT > $WARN 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$WARN" "$BASEWARN" "$TEST stderr output"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

cleanUpAfterTests
