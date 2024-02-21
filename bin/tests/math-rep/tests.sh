#!/bin/bash
# Shell script based test plan
# set -e gotchas http://mywiki.wooledge.org/BashFAQ/105
set -e

# What we're testing and sample input data
PROGRAM=../../math-rep.pl
CMD=`basename $PROGRAM`
SAMPLE=in/math-rep.sample.txt
SINGLE=in/single.txt
LITERALS=in/literals.txt
MARKUP=in/markup.txt
NAMED=in/named.txt
DEBUG=
SKIP=0

# Include testing library and make output dir exist
source ../shell-test.sh
PLAN 15

[ -d out ] || mkdir out
rm out/* > /dev/null 2>&1 || OK "output dir ready"

# Do not terminate test plan if out/base comparison fails.
ERROR_STOP=0

# Filter an output file to remove changing text like dates, etc...
function filter {
	local file
	file="$1"
	perl -i -pne 's{(?:\S+)(/bin/character-samples/)}{/PATH$1}xms' $file
#	perl -i -pne 's{DONOTFILTER\w+\s+\(\w+\)}{NAME (ROLE)}xms' $file
}

echo TEST $CMD command help
TEST=command-help
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --help $SAMPLE"
	$PROGRAM $ARGS > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD command manual page
TEST=command-manpage
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --man $SAMPLE"
	$PROGRAM $ARGS > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

#echo TEST $CMD command invalid option
#TEST=command-invalid
#if [ 0 == "$SKIP" ]; then
#	ERR=0
#	EXPECT=1
#	OUT=out/$TEST.out
#	BASE=base/$TEST.base
#	ARGS="$DEBUG --invalid $SAMPLE"
#	$PROGRAM $ARGS > $OUT 2>&1 || ERR=$?
#	assertCommandFails $ERR $EXPECT "$PROGARM $ARGS"
#	assertFilesEqual "$OUT" "$BASE" "$TEST"
#else
#	echo SKIP $TEST "$SKIP"
#fi

#echo TEST $CMD command incompatible options
#TEST=command-incompatible-options
#if [ 0 == "$SKIP" ]; then
#	ERR=0
#	EXPECT=1
#	OUT=out/$TEST.out
#	BASE=base/$TEST.base
#	ARGS="$DEBUG --inplace --keep $SAMPLE"
#	$PROGRAM $ARGS 2>&1 | head -3 > $OUT
#	assertFilesEqual "$OUT" "$BASE" "$TEST"
#else
#	echo SKIP $TEST "$SKIP"
#fi

#echo TEST $CMD command inplace and show are incompatible
#TEST=command-invalid-inplace-show
#if [ 0 == "$SKIP" ]; then
#	ERR=0
#	EXPECT=1
#	OUT=out/$TEST.out
#	BASE=base/$TEST.base
#	ARGS="$DEBUG --inplace --show $SAMPLE"
#	$PROGRAM $ARGS 2>&1 | head -3 > $OUT
#	assertFilesEqual "$OUT" "$BASE" "$TEST"
#else
#	echo SKIP $TEST "$SKIP"
#fi

echo TEST $CMD successful single replacement to debug
TEST=single
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	DEBUG=1 $PROGRAM $ARGS < $SINGLE 2> $OUT.err > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	echo "DEBUGGING: less $OUT.err"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful use of showing U+ code instead of utf8
TEST=show-codes
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	SHOW_CODE=1 $PROGRAM $ARGS < $SINGLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful legend mode by name
TEST=legend-names
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	LEGEND=names $PROGRAM $ARGS < $LITERALS > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful legend mode by character
TEST=legend-chars
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	LEGEND=chars $PROGRAM $ARGS < $LITERALS > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful literal replacements
TEST=literal
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	MARKUP=0 $PROGRAM $ARGS < $LITERALS > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD literal replacements turned off
TEST=no-literals
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=$LITERALS
	ARGS="$DEBUG"
	LITERAL=0 $PROGRAM $ARGS < $LITERALS > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful markup replacements
TEST=markup
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	LITERAL=0 $PROGRAM $ARGS < $MARKUP > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD markup replacements turned off
TEST=no-markup
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=$MARKUP
	ARGS="$DEBUG"
	MARKUP=0 $PROGRAM $ARGS < $MARKUP > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful named markup replacements
TEST=markup-named
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	LITERAL=0 $PROGRAM $ARGS < $NAMED > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful operation
TEST=success
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

cleanUpAfterTests
