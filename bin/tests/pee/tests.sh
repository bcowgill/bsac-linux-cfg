#!/bin/bash
# Shell script based test plan
# set -e gotchas http://mywiki.wooledge.org/BashFAQ/105
set -e

# What we're testing and sample input data
PROGRAM=../../pee.pl
CMD=`basename $PROGRAM`
SAMPLE=in/SAMPLE.ctrl.txt
SAMPLE2=../filter-man/in/sample1.txt
SAMPLE3=in/sample-script-ansi-escapes.log
RULER=in/ruler.txt
DCS=in/control.txt
DEBUG=
SKIP=0

COLUMNS=

# Include testing library and make output dir exist
source ../shell-test.sh
PLAN 25

[ -d out ] || mkdir out
rm out/* > /dev/null 2>&1 || OK "output dir ready"

# Do not terminate test plan if out/base comparison fails.
ERROR_STOP=0

# Filter an output file to remove changing text like dates, etc...
function filter {
	local file TMP
	file="$1"
	TMP=`mktemp`
	filter-generify.pl $file > "$TMP"
	dos2unix --force "$TMP" 2> /dev/null
	mv "$TMP" "$file"
}

# Set up sample file with control characters for testing...
cp in/SAMPLE.txt $SAMPLE
$PROGRAM --test >> $SAMPLE

echo TEST $CMD command help
TEST=command-help
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	BASELOG=base/$TEST.log.base
	ARGS="$DEBUG --help"
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
	BASELOG=base/$TEST.log.base
	ARGS="$DEBUG --invalid"
	$PROGRAM $ARGS > $OUT 2>&1 || ERR=$?
	assertCommandFails $ERR $EXPECT "$PROGARM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD command missing filename
TEST=command-missing-filename
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=1
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	BASELOG=base/$TEST.log.base
	ARGS="$DEBUG"
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
	LOG=out/$TEST.log.out
	BASE=base/$TEST.base
	BASELOG=base/$TEST.log.base
	ARGS="$DEBUG $LOG"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	filter "$LOG"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	assertFilesEqual "$LOG" "$BASELOG" "$TEST logfile"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful operation custom wrap
TEST=success-wrap-custom
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	LOG=out/$TEST.log.out
	BASE=base/$TEST.base
	BASELOG=base/$TEST.log.base
	ARGS="$DEBUG $LOG"
	COLUMNS=40 $PROGRAM $ARGS < $RULER > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	filter "$LOG"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	assertFilesEqual "$LOG" "$BASELOG" "$TEST logfile"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful operation no wrap
TEST=success-wrap-none
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	LOG=out/$TEST.log.out
	BASE=base/$TEST.base
	BASELOG=base/$TEST.log.base
	ARGS="$DEBUG $LOG"
	COLUMNS=0 $PROGRAM $ARGS < $RULER > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	filter "$LOG"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	assertFilesEqual "$LOG" "$BASELOG" "$TEST logfile"
else
	echo SKIP $TEST "$SKIP"
fi

COLUMNS=0

echo TEST $CMD successful operation with append
TEST=success-append
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	LOG=out/$TEST.log.out
	BASE=base/$TEST.base
	BASELOG=base/$TEST.log.base
	ARGS="$DEBUG --append $LOG"
	echo "This text is already in the log file." > $LOG
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	filter "$LOG"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	assertFilesEqual "$LOG" "$BASELOG" "$TEST logfile"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful operation with removal of control characters
TEST=success-control
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	LOG=out/$TEST.log.out
	BASE=base/$TEST.base
	BASELOG=base/$TEST.log.base
	ARGS="$DEBUG --control $LOG"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	filter "$LOG"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	assertFilesEqual "$LOG" "$BASELOG" "$TEST logfile"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful operation with removal of dcs control characters
TEST=success-dcs
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	LOG=out/$TEST.log.out
	BASE=base/$TEST.base
	BASELOG=base/$TEST.log.base
	ARGS="$DEBUG --control $LOG"
	$PROGRAM $ARGS < $DCS > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	filter "$LOG"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	assertFilesEqual "$LOG" "$BASELOG" "$TEST logfile"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful operation script log
TEST=success-script-log
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	LOG=out/$TEST.log.out
	BASE=base/$TEST.base
	BASELOG=base/$TEST.log.base
	ARGS="$DEBUG $LOG"
	$PROGRAM --control $ARGS < $SAMPLE2 > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	filter "$LOG"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	assertFilesEqual "$LOG" "$BASELOG" "$TEST logfile"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful operation ansi log
TEST=success-ansi
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	LOG=out/$TEST.log.out
	BASE=base/$TEST.base
	BASELOG=base/$TEST.log.base
	ARGS="$DEBUG $LOG"
	$PROGRAM --control $ARGS < $SAMPLE3 > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	filter "$LOG"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	assertFilesEqual "$LOG" "$BASELOG" "$TEST logfile"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful operation update every 10 lines
TEST=success-update-10
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	LOG=out/$TEST.log.out
	BASE=base/$TEST.base
	BASELOG=base/$TEST.log.base
	ARGS="$DEBUG $LOG"
	UPDATE=10 $PROGRAM $ARGS < $RULER > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	filter "$LOG"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	assertFilesEqual "$LOG" "$BASELOG" "$TEST logfile"
else
	echo SKIP $TEST "$SKIP"
fi

cleanUpAfterTests
