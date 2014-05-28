#!/bin/bash
set -e

PROGRAM=../../ls-tt-tags.pl
SAMPLE=template-toolkit-test.txt
DEBUG=--debug
DEBUG=

source ../shell-test.sh

[ -d out ] || mkdir out
rm out/* > /dev/null 2>&1 || echo OK output dir ready

echo TEST basic operation
TEST=basic-operation
OUT=out/$TEST.out
BASE=base/$TEST.base

# MUSTDO command line options instead of ENV vars
export LS_TT_TAGS_INLINE=0
export LS_TT_TAGS_ECHO=0

$PROGRAM $DEBUG < $SAMPLE > $OUT
assertFilesEqual "$OUT" "$BASE" "$TEST"

echo TEST echo filename
TEST=echo-filename
OUT=out/$TEST.out
BASE=base/$TEST.base

# MUSTDO command line options instead of ENV vars
export LS_TT_TAGS_INLINE=0
export LS_TT_TAGS_ECHO=1

$PROGRAM $DEBUG $SAMPLE > $OUT
assertFilesEqual "$OUT" "$BASE" "$TEST"

echo TEST tags inline
TEST=tags-inline
OUT=out/$TEST.out
BASE=base/$TEST.base

# MUSTDO command line options instead of ENV vars
export LS_TT_TAGS_INLINE=1
export LS_TT_TAGS_ECHO=0

$PROGRAM $DEBUG $SAMPLE > $OUT
assertFilesEqual "$OUT" "$BASE" "$TEST"

# clean up output directory if no failures
rm out/* && rmdir out
echo OK All tests complete `pwd`/out cleaned up
