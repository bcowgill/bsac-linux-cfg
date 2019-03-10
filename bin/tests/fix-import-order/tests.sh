#!/bin/bash
# Shell script based test plan
# set -e gotchas http://mywiki.wooledge.org/BashFAQ/105
set -e

# What we're testing and sample input data
PROGRAM=../../fix-import-order.pl
CMD=`basename $PROGRAM`
SAMPLE=in/sample1.js
DEBUG=--debug
DEBUG=
SKIP=0

# Include testing library and make output dir exist
source ../shell-test.sh
PLAN 6

[ -d out ] || mkdir out
rm out/* > /dev/null 2>&1 || OK "output dir ready"

# Do not terminate test plan if out/base comparison fails.
ERROR_STOP=0

echo TEST $CMD usage
TEST=usage
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --help"
	$PROGRAM $ARGS > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD sample
TEST=sample
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	STDOUT=out/$TEST.std.out
	BASE=base/$TEST.base
	STDBASE=base/$TEST.std.base
	SAMPLE=in/$TEST.js
	ARGS="$DEBUG $OUT"
	cp $SAMPLE $OUT
	$PROGRAM $ARGS > $STDOUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$STDOUT" "$STDBASE" "$TEST"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

#stop "simulating a failure so all .html output remains behind for front end behaviour verification"

cleanUpAfterTests
