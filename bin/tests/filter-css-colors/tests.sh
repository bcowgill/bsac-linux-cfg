#!/bin/bash
# Shell script based test plan
set -e

# What we're testing and sample input data
PROGRAM=../../filter-css-colors.pl
SAMPLE=filter-css-colors-test.txt
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
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
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
	$PROGRAM $ARGS < $SAMPLE > $OUT 2>&1 || ERR=$?
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
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

echo TEST no options set
TEST=no-options
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS=""
	$PROGRAM $DEBUG < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

echo TEST all options turned off acts as a grep for CSS color declarations
TEST=noecho-noreverse-nocolor-noremap-nocanon-nonames
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --noecho --noreverse --nocolor-only --noremap --nocanonical --nonames"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

echo TEST From file and --reverse only acts as a grep -v for CSS color declarations
TEST=noecho-reverse-nocolor-noremap-nocanon-nonames
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --noecho --reverse --nocolor-only --noremap --nocanonical --nonames $SAMPLE"
	$PROGRAM $ARGS > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

echo TEST --color-only greps and shows only the CSS color values
TEST=noecho-noreverse-color-noremap-nocanon-nonames
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --noecho --noreverse --color-only --noremap --nocanonical --nonames"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

echo TEST --remap only without --names or --canonical just acts as grep
TEST=noecho-noreverse-nocolor-remap-nocanon-nonames
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --noecho --noreverse --nocolor-only --remap --nocanonical --nonames"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

echo TEST --canonical only implies --remap
TEST=noecho-noreverse-nocolor-noremap-canon-nonames
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --noecho --noreverse --nocolor-only --noremap --canonical --nonames"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

echo TEST --names only implies --remap and --canonical
TEST=noecho-noreverse-nocolor-noremap-nocanon-names
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --noecho --noreverse --nocolor-only --noremap --nocanonical --names"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

#SKIP="NOT YET IMPLEMENTED"

echo TEST --rgb only implies --remap and --canonical
TEST=noecho-noreverse-nocolor-noremap-nocanon-nonames-rgb
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --noecho --noreverse --nocolor-only --noremap --nocanonical --nonames --rgb"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

SKIP=0

echo TEST --remap --canonical and --names against previous test base file
TEST=noecho-noreverse-nocolor-remap-canon-names
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/noecho-noreverse-nocolor-noremap-nocanon-names.base
	ARGS="$DEBUG --noecho --noreverse --nocolor-only --remap --canonical --names"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

echo TEST --echo --names shows original line and changed line
TEST=echo-noreverse-nocolor-noremap-nocanon-nonames
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --echo --noreverse --nocolor-only --noremap --nocanonical --names"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

echo "TEST --valid-only --names will not convert rgba(0,0,0,0.3) to rgba(black,0.3)"
TEST=validonly-names
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --valid-only --names"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

echo TEST --inplace=.bak --names test in place modification with backup file
TEST=inplace
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --inplace=.bak --names $OUT"

	cp $SAMPLE $OUT
	$PROGRAM $ARGS || assertCommandSuccess $? "$PROGRAM $ARGS"
	# check original was backed up
	assertFilesEqual "$SAMPLE" "$OUT.bak" "$TEST backup created"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

# clean up output directory if no failures
rm out/* && rmdir out
echo OK All tests complete `pwd`/out cleaned up
