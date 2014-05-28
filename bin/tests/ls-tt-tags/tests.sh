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

echo TEST basic operation
TEST=basic-operation
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"

	# MUSTDO command line options instead of ENV vars
	export LS_TT_TAGS_INLINE=0
	export LS_TT_TAGS_ECHO=0

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
	ARGS="$DEBUG $SAMPLE"

	# MUSTDO command line options instead of ENV vars
	export LS_TT_TAGS_INLINE=0
	export LS_TT_TAGS_ECHO=1

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
	ARGS="$DEBUG $SAMPLE"

	# MUSTDO command line options instead of ENV vars
	export LS_TT_TAGS_INLINE=1
	export LS_TT_TAGS_ECHO=0

	$PROGRAM $ARGS > $OUT || assertCommandSuccess $?
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

# clean up output directory if no failures
rm out/* && rmdir out
echo OK All tests complete `pwd`/out cleaned up
