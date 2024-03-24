#!/bin/bash
# Shell script based test plan
# set -e gotchas http://mywiki.wooledge.org/BashFAQ/105
set -e

# What we're testing and sample input data
PROGRAM=../../filter-script.pl
CMD=`basename $PROGRAM`
SAMPLE=in/setup-playwright.txt
SAMPLE2=in/setup-playwright-ts.txt
SAMPLE3=in/signoff-line-extra-esc.txt
SAMPLE4=in/with-codes.txt
DEBUG=
SKIP=0

# Include testing library and make output dir exist
source ../shell-test.sh
PLAN 14

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

function check_clean {
	local file
	file="$1"
	file=$file perl -ne 'if (m{\x1b|\x07}xms)
		{
			s{\x1b}{ ESC }xmsg;
			s{\x07}{ BEL }xmsg;
			s{\x08}{ BS }xmsg;
			s{\x9b}{ CSI }xmsg;
			s{\x9d}{ OSC }xmsg;
			s{\x90}{ DCS }xmsg;
			print "#OOPS $ENV{file} line $.: $_";
			exit 1;
		}' "$file"
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
	assertCommandFails $ERR $EXPECT "$PROGARM $ARGS"
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
	ARGS="$DEBUG --inplace --keep $SAMPLE"
	$PROGRAM $ARGS 2>&1 | head -3 > $OUT
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD command inplace and show are incompatible
TEST=command-invalid-inplace-show
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=1
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --inplace --show $SAMPLE"
	$PROGRAM $ARGS 2>&1 | head -3 > $OUT
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
   check_clean "$OUT" || assertCommandSuccess $? "Escape codes remain in output for $OUT."
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful operation typescript log
TEST=success-typescript
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$PROGRAM $ARGS < $SAMPLE2 > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
   check_clean "$OUT" || assertCommandSuccess $? "Escape codes remain in output for $OUT."
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful operation show codes
TEST=success-prompt
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	ERR=out/$TEST.err.out
	BASE=base/$TEST.base
	BASE_ERR=base/$TEST.err.base
	ARGS="$DEBUG --codes"
	$PROGRAM $ARGS < $SAMPLE3 > $OUT 2> $ERR || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	filter "$ERR"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	assertFilesEqual "$ERR" "$BASE_ERR" "$TEST error output"
   #check_clean "$OUT" || assertCommandSuccess $? "Escape codes remain in output for $OUT."
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful operation show codes
TEST=success-codes
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	ERR=out/$TEST.err.out
	BASE=base/$TEST.base
	BASE_ERR=base/$TEST.err.base
	ARGS="$DEBUG --codes"
	$PROGRAM $ARGS < $SAMPLE4 > $OUT 2> $ERR || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	filter "$ERR"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	assertFilesEqual "$ERR" "$BASE_ERR" "$TEST error output"
else
	echo SKIP $TEST "$SKIP"
fi

cleanUpAfterTests
