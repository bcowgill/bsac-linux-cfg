#!/bin/bash
set -e

PROGRAM=../../ls-tt-tags.pl
SAMPLE=template-toolkit-test.txt
DEBUG=--debug
DEBUG=

source ../shell-test.sh

[ -d out ] || mkdir out
rm out/* || echo OK output dir ready

echo TEST basic operation
TEST=basic-operation
OUT=out/$TEST.out
BASE=base/$TEST.base
$PROGRAM $DEBUG < $SAMPLE > $OUT
assertFilesEqual "$OUT" "$BASE" "$TEST"

# clean up output directory if no failures
rm out/* && rmdir out
echo OK All tests complete `pwd`/out cleaned up
