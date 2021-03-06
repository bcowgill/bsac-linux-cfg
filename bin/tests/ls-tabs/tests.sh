#!/bin/bash
# Shell script based test plan
# set -e gotchas http://mywiki.wooledge.org/BashFAQ/105
set -e

# What we're testing and sample input data
PROGRAM=../../ls-tabs.pl
CMD=`basename $PROGRAM`
SAMPLE=in/sample.txt
DEBUG=--debug
DEBUG=
SKIP=0

# Include testing library and make output dir exist
source ../shell-test.sh
PLAN 12

[ -d out ] || mkdir out
rm out/* > /dev/null 2>&1 || OK "output dir ready"

# Do not terminate test plan if out/base comparison fails.
ERROR_STOP=0

echo TEST $CMD --version option
TEST=version-option
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --version"
	$PROGRAM $ARGS > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	perl -i -pne 's{version \s+ [\d\.]+}{version X.XX}xmsg' "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD unknown option
TEST=unknown-option
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=1
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --unknown-option"
	$PROGRAM $ARGS > $OUT 2>&1 || ERR=$?
	assertCommandFails $ERR $EXPECT "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD --man option
TEST=man-option
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --man"
	$PROGRAM $ARGS | filter-man.pl > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	perl -i -pne 's{(perl \s+ v)[\d\.]+(\s+\d{4}-\d{2}-\d{2})}{${1}X.XX$2}xms; s{\d\d\d\d-\d\d-\d\d}{YYYY-MM-DD}xms' "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

SKIP=0
echo TEST $CMD normal operation
TEST=normal
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG $SAMPLE"
#	echo $PROGRAM $ARGS to $OUT
	$PROGRAM $ARGS > $OUT || assertCommandFails $? 1 "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD tabsize override
TEST=set-size
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --spaces=3 $SAMPLE"
	$PROGRAM $ARGS > $OUT || assertCommandFails $? 1 "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD good indentation file
TEST=good
SAMPLE=in/good.txt
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --spaces=3"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

cleanUpAfterTests

