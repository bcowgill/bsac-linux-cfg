#!/bin/bash
set -e

PROGRAM=../../filter-css-colors.pl
SAMPLE=filter-css-colors-test.txt

source ../shell-test.sh

[ -d out ] || mkdir out

TEST=noecho-reverse-nocolor-noremap-nocanon-nonames
OUT=out/$TEST.out
BASE=base/$TEST.base
$PROGRAM < $SAMPLE > $OUT
assertFilesEqual "$OUT" "$BASE" "$TEST"

TEST=noecho-noreverse-nocolor-noremap-nocanon-nonames
OUT=out/$TEST.out
BASE=base/$TEST.base
$PROGRAM < $SAMPLE > $OUT
assertFilesEqual "$OUT" "$BASE" "$TEST"

TEST=noecho-noreverse-nocolor-remap-canon-names
OUT=out/$TEST.out
BASE=base/$TEST.base
$PROGRAM < $SAMPLE > $OUT
assertFilesEqual "$OUT" "$BASE" "$TEST"

TEST=echo-noreverse-nocolor-remap-canon-names
OUT=out/$TEST.out
BASE=base/$TEST.base
$PROGRAM < $SAMPLE > $OUT
assertFilesEqual "$OUT" "$BASE" "$TEST"

echo OK All tests complete
