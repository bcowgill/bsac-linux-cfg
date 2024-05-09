#!/bin/bash
# Shell script based test plan
# set -e gotchas http://mywiki.wooledge.org/BashFAQ/105
set -e

# What we're testing and sample input data
PROGRAM=../../css-color-scale.pl
CMD=`basename $PROGRAM`
SAMPLE=in/SAMPLE.txt
DEBUG=
SKIP=0
HEAD=3

# Include testing library and make output dir exist
source ../shell-test.sh
PLAN 18

[ -d out ] || mkdir out
rm out/* > /dev/null 2>&1 || OK "output dir ready"

# Do not terminate test plan if out/base comparison fails.
ERROR_STOP=0

# Filter an output file to remove changing text like dates, etc...
function filter {
	local file
	file="$1"
	perl -i -pne 's{DONOTFILTER\w+\s+\(\w+\)}{NAME (ROLE)}xms' $file
}

echo TEST $CMD command help
TEST=command-help
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

echo TEST $CMD command invalid option
TEST=command-invalid
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=1
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --invalid $SAMPLE"
	$PROGRAM $ARGS > $OUT 2>&1 || ERR=$?
	assertCommandFails $ERR $EXPECT "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD command invalid rgb value
TEST=command-invalid-rgb
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=1
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG 123 211 456"
	$PROGRAM $ARGS 2>&1 | head -$HEAD > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD command invalid color
TEST=command-invalid-color
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=1
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG #000"
	$PROGRAM $ARGS 2>&1 | head -$HEAD > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD command incompatible options
TEST=command-incompatible-options
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=1
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG 10 11 12 42"
	$PROGRAM $ARGS 2>&1 | head -$HEAD > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD command hex and rgb are incompatible
TEST=command-invalid-hex-red
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=1
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG '123'  123 123 js-file.js css-file.css"
	$PROGRAM $ARGS 2>&1 | head -$HEAD > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD command has too many parameters
TEST=command-invalid-too-many
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=1
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG #3c2419 js-file.js 123 456 css-file.css"
	$PROGRAM $ARGS 2>&1 | head -$HEAD > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD command has too many parameters #2
TEST=command-invalid-too-many2
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=1
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG #3c2419 COLOR js-file.js 123 css-file.css"
	$PROGRAM $ARGS 2>&1 | head -$HEAD > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful operation
TEST=success
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST-css.out
	OUT2=out/$TEST-js.out
	BASE=base/$TEST-css.base
	BASE2=base/$TEST-js.base
	ARGS="$DEBUG #3c7e9f"
	$PROGRAM $ARGS > $OUT 2> $OUT2 || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	filter "$OUT2"
	assertFilesEqual "$OUT" "$BASE" "$TEST css on STDOUT"
	assertFilesEqual "$OUT2" "$BASE2" "$TEST js on STDERR"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful operation filenames
TEST=success-names
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST-css.out
	OUT2=out/$TEST-js.out
	BASE=base/$TEST-css.base
	BASE2=base/$TEST-js.base
	ARGS="$DEBUG #3c7e9f MYHUE $OUT2 $OUT"
	$PROGRAM $ARGS || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	filter "$OUT2"
	assertFilesEqual "$OUT" "$BASE" "$TEST css on STDOUT"
	assertFilesEqual "$OUT2" "$BASE2" "$TEST js on STDERR"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful operation no-scale
TEST=success-no-scale
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST-css.out
	OUT2=out/$TEST-js.out
	BASE=base/$TEST-css.base
	BASE2=base/$TEST-js.base
	ARGS="$DEBUG #3c7e9f MYHUE $OUT2 $OUT"
	USE_COLOR=1 $PROGRAM $ARGS || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	filter "$OUT2"
	assertFilesEqual "$OUT" "$BASE" "$TEST css on STDOUT"
	assertFilesEqual "$OUT2" "$BASE2" "$TEST js on STDERR"
else
	echo SKIP $TEST "$SKIP"
fi

cleanUpAfterTests
