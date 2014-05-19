#!/bin/bash
set -e

PROGRAM=../../filter-css-colors.pl
SAMPLE=filter-css-colors-test.txt
DEBUG=--debug
DEBUG=

source ../shell-test.sh

[ -d out ] || mkdir out
rm out/* || echo OK output dir ready

echo TEST --version option
TEST=version-option
OUT=out/$TEST.out
BASE=base/$TEST.base
$PROGRAM $DEBUG --version < $SAMPLE > $OUT
assertFilesEqual "$OUT" "$BASE" "$TEST"

echo TEST unknown option
TEST=unknown-option
OUT=out/$TEST.out
BASE=base/$TEST.base
$PROGRAM $DEBUG --unknown-option < $SAMPLE > $OUT 2>&1 || echo OK program exit with $?
assertFilesEqual "$OUT" "$BASE" "$TEST"

echo TEST --man option
TEST=man-option
OUT=out/$TEST.out
BASE=base/$TEST.base
$PROGRAM $DEBUG --man < $SAMPLE > $OUT
assertFilesEqual "$OUT" "$BASE" "$TEST"

echo TEST no options set
TEST=no-options
OUT=out/$TEST.out
BASE=base/$TEST.base
$PROGRAM $DEBUG < $SAMPLE > $OUT
assertFilesEqual "$OUT" "$BASE" "$TEST"

echo TEST all options turned off acts as a grep for CSS color declarations
TEST=noecho-noreverse-nocolor-noremap-nocanon-nonames
OUT=out/$TEST.out
BASE=base/$TEST.base
$PROGRAM $DEBUG --noecho --noreverse --nocolor-only --noremap --nocanonical --nonames < $SAMPLE > $OUT
assertFilesEqual "$OUT" "$BASE" "$TEST"

echo TEST From file and --reverse only acts as a grep -v for CSS color declarations
TEST=noecho-reverse-nocolor-noremap-nocanon-nonames
OUT=out/$TEST.out
BASE=base/$TEST.base
$PROGRAM $DEBUG --noecho --reverse --nocolor-only --noremap --nocanonical --nonames $SAMPLE > $OUT
assertFilesEqual "$OUT" "$BASE" "$TEST"

echo TEST --color-only greps and shows only the CSS color values
TEST=noecho-noreverse-color-noremap-nocanon-nonames
OUT=out/$TEST.out
BASE=base/$TEST.base
$PROGRAM $DEBUG --noecho --noreverse --color-only --noremap --nocanonical --nonames < $SAMPLE > $OUT
assertFilesEqual "$OUT" "$BASE" "$TEST"

echo TEST --remap only without --names or --canonical just acts as grep
TEST=noecho-noreverse-nocolor-remap-nocanon-nonames
OUT=out/$TEST.out
BASE=base/$TEST.base
$PROGRAM $DEBUG --noecho --noreverse --nocolor-only --remap --nocanonical --nonames < $SAMPLE > $OUT
assertFilesEqual "$OUT" "$BASE" "$TEST"

echo TEST --canonical only implies --remap
TEST=noecho-noreverse-nocolor-noremap-canon-nonames
OUT=out/$TEST.out
BASE=base/$TEST.base
$PROGRAM $DEBUG --noecho --noreverse --nocolor-only --noremap --canonical --nonames < $SAMPLE > $OUT
assertFilesEqual "$OUT" "$BASE" "$TEST"

echo TEST --names only implies --remap and --canonical
TEST=noecho-noreverse-nocolor-noremap-nocanon-names
OUT=out/$TEST.out
BASE=base/$TEST.base
$PROGRAM $DEBUG --noecho --noreverse --nocolor-only --noremap --nocanonical --names < $SAMPLE > $OUT
assertFilesEqual "$OUT" "$BASE" "$TEST"

echo TEST --rgb only implies --remap and --canonical
TEST=noecho-noreverse-nocolor-noremap-nocanon-nonames-rgb
OUT=out/$TEST.out
BASE=base/$TEST.base
$PROGRAM $DEBUG --noecho --noreverse --nocolor-only --noremap --nocanonical --nonames --rgb < $SAMPLE > $OUT
assertFilesEqual "$OUT" "$BASE" "$TEST"

echo TEST --remap --canonical and --names against previous test base file
TEST=noecho-noreverse-nocolor-remap-canon-names
OUT=out/$TEST.out
BASE=base/noecho-noreverse-nocolor-noremap-nocanon-names.base
$PROGRAM $DEBUG --noecho --noreverse --nocolor-only --remap --canonical --names < $SAMPLE > $OUT
assertFilesEqual "$OUT" "$BASE" "$TEST"

echo TEST --echo --names shows original line and changed line
TEST=echo-noreverse-nocolor-noremap-nocanon-nonames
OUT=out/$TEST.out
BASE=base/$TEST.base
$PROGRAM $DEBUG --echo --noreverse --nocolor-only --noremap --nocanonical --names < $SAMPLE > $OUT
assertFilesEqual "$OUT" "$BASE" "$TEST"

echo "TEST --valid-only --names will not convert rgba(0,0,0,0.3) to rgba(black,0.3)"
TEST=validonly-names
OUT=out/$TEST.out
BASE=base/$TEST.base
$PROGRAM $DEBUG --valid-only --names < $SAMPLE > $OUT
assertFilesEqual "$OUT" "$BASE" "$TEST"

echo TEST --inplace=.bak --names test in place modification with backup file
TEST=inplace
OUT=out/$TEST.out
BASE=base/$TEST.base
cp $SAMPLE $OUT
$PROGRAM $DEBUG --inplace=.bak --names $OUT
# check original was backed up
assertFilesEqual "$SAMPLE" "$OUT.bak" "$TEST backup created"
assertFilesEqual "$OUT" "$BASE" "$TEST"

# clean up output directory if no failures
rm out/* && rmdir out
echo OK All tests complete `pwd`/out cleaned up
