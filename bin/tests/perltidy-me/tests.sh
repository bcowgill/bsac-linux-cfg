#!/bin/bash
# Shell script based test plan
# set -e gotchas http://mywiki.wooledge.org/BashFAQ/105
set -e

# What we're testing and sample input data
PROGRAM=perltidy
SAMPLE=in/perltidy-me.pl
DEBUG=--debug
DEBUG=
SKIP=0
TIDYARGS="--standard-output --standard-error-output --warning-output --logfile --DEBUG"
PROFILE=--noprofile

# Include testing library and make output dir exist
source ../shell-test.sh
[ -d out ] || mkdir out
rm out/* > /dev/null 2>&1 || echo OK output dir ready

echo TEST perltidy token type dump
TEST=token-type-dump
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG $TIDYARGS $PROFILE --dump-token-types $SAMPLE"
	$PROGRAM $ARGS > $OUT 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	perl -i -pne 's{ \A ([a-z]) }{--$1}xms' $OUT
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

echo TEST perltidy default formatting options
TEST=default-formatting-options-dump
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG $TIDYARGS $PROFILE --dump-defaults $SAMPLE"
	$PROGRAM $ARGS > $OUT 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	perl -i -pne 's{ \A ([a-z]) }{--$1}xms' $OUT
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

echo TEST perltidy default want left space
TEST=default-want-left-space-dump
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG $TIDYARGS $PROFILE --dump-want-left-space $SAMPLE"
	$PROGRAM $ARGS > $OUT 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

echo TEST perltidy default want right space
TEST=default-want-right-space-dump
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG $TIDYARGS $PROFILE --dump-want-right-space $SAMPLE"
	$PROGRAM $ARGS > $OUT 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

echo TEST perltidy default formatting
TEST=default-formatting
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out.pl
	BASE=base/$TEST.base.pl
	ARGS="$DEBUG $TIDYARGS $PROFILE $SAMPLE"
	$PROGRAM $ARGS > $OUT 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

PROFILE="--profile=$HOME/bin/cfg/.perltidyrc"

echo TEST perltidy my personal formatting options
TEST=bsac-personal-options-dump
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG $TIDYARGS $PROFILE --dump-options $SAMPLE"
	$PROGRAM $ARGS > $OUT 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

echo TEST perltidy my personal want left space
TEST=bsac-personal-want-left-space-dump
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG $TIDYARGS $PROFILE --dump-want-left-space $SAMPLE"
	$PROGRAM $ARGS > $OUT 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

echo TEST perltidy my personal want right space
TEST=bsac-personal-want-right-space-dump
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG $TIDYARGS $PROFILE --dump-want-right-space $SAMPLE"
	$PROGRAM $ARGS > $OUT 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

echo TEST perltidy my personal formatting
TEST=bsac-personal
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out.pl
	BASE=base/$TEST.base.pl
	ARGS="$DEBUG $TIDYARGS $PROFILE $SAMPLE"
	$PROGRAM $ARGS > $OUT 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

PROFILE="--profile=$HOME/bin/cfg/.perltidyrc-blismedia"

echo TEST perltidy blismedia formatting
TEST=blismedia
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out.pl
	BASE=base/$TEST.base.pl
	ARGS="$DEBUG $TIDYARGS $PROFILE $SAMPLE"
	$PROGRAM $ARGS > $OUT 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
   echo SKIP $TEST "$SKIP"
fi

# clean up output directory if no failures
rm out/* && rmdir out
echo OK All tests complete `pwd`/out cleaned up
