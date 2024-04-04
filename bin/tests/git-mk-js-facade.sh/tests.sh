#!/bin/bash
# Shell script based test plan
# set -e gotchas http://mywiki.wooledge.org/BashFAQ/105
set -e

# What we're testing and sample input data
PROGRAM=../../git-mk-js-facade.sh
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
PLAN 7

[ -d out ] || mkdir out
rm out/* > /dev/null 2>&1 || OK "output dir ready"

# Do not terminate test plan if out/base comparison fails.
ERROR_STOP=0

# nvm use v12.19.0 or better...
PROGRAM2=node

if $PROGRAM2 --version | grep -E '(v1[23456789]|v[23456789]\d)\.' ; then
	OK "node version is sufficient"
else
	NOT_OK "node version is insufficient to run these tests. see .nvmrc file."
	exit 1
fi

echo TEST export default main
TEST=default
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG in/$TEST/main.js"
	NODE_PRESERVE_SYMLINKS=1 $PROGRAM2 $ARGS > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST export named main
TEST=named
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG in/$TEST/main.js"
	NODE_PRESERVE_SYMLINKS=1 $PROGRAM2 $ARGS > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST export all main
TEST=all
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG in/$TEST/main.js"
	NODE_PRESERVE_SYMLINKS=1 $PROGRAM2 $ARGS > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

# MUSTDO for each default, named, all create git repo and add files to it then run git-mk-js-facade to rename the file and run node command again to verify output.


cleanUpAfterTests
exit
SKIP=1
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

echo TEST $CMD duplicate-warning
TEST=$SUITE-warning-duplicate
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	WARN=out/$TEST.warn.out
	BASE=base/$TEST.base
	BASEWARN=base/$TEST.warn.base
	ARGS="$DEBUG"
	$PROGRAM $ARGS $DUPLICATE $EMPTY1 2> $WARN > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
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

echo TEST $CMD successful operation everything added
TEST=$SUITE-success-all-added
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

echo TEST $CMD successful operation no overrides
TEST=$SUITE-success-no-overrides
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
