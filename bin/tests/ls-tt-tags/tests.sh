#!/bin/bash
# Shell script based test plan
set -e

# What we're testing and sample input data
PROGRAM=../../ls-tt-tags.pl
SAMPLE=template-toolkit-test.txt
DEBUG=--debug
DEBUG=
SKIP=0

# Include testing library and make output dir exist
source ../shell-test.sh
[ -d out ] || mkdir out
rm out/* > /dev/null 2>&1 || echo OK output dir ready

echo TEST --version option
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

echo TEST unknown option
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

echo TEST --man option
TEST=man-option
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --man"
	$PROGRAM $ARGS > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	perl -i -pne 's{(perl \s+ v)[\d\.]+(\s+\d{4}-\d{2}-\d{2})}{${1}X.XX$2}xms' "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

echo TEST basic operation
TEST=basic-operation
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --noinline-block --noecho-filename"

	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

echo TEST echo filename
TEST=echo-filename
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --noinline-block --echo-filename $SAMPLE"

	$PROGRAM $ARGS > $OUT || assertCommandSuccess $?
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

echo TEST tags inline
TEST=tags-inline
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --inline-block --noecho-filename $SAMPLE"

	$PROGRAM $ARGS > $OUT || assertCommandSuccess $?
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

echo TEST echo filename and standard input is error
TEST=echo-filename-stdin-error
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --noinline-block --echo-filename"

	$PROGRAM $ARGS < $SAMPLE > $OUT 2>&1 || ERR=$?
	assertCommandFails $ERR $EXPECT "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

# clean up output directory if no failures
rm out/* && rmdir out
echo OK All tests complete `pwd`/out cleaned up
