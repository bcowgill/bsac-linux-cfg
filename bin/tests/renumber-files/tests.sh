#!/bin/bash
# Shell script based test plan
# set -e gotchas http://mywiki.wooledge.org/BashFAQ/105
set -e

# What we're testing and sample input data
PROGRAM=../../renumber-files.sh
CMD=`basename $PROGRAM`
TAR=../../in/screenshots.tgz
SAMPLE=./out/xyzzy
DEBUG=
SKIP=0
HEAD=3

# Include testing library and make output dir exist
source ../shell-test.sh
PLAN 13

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

function setup {
	[ -d out/xyzzy ] && rm -rf out/xyzzy
	mkdir -p out/xyzzy
	pushd out/xyzzy > /dev/null
	tar xzf $TAR
	popd > /dev/null
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

echo TEST $CMD command missing new name prefix
TEST=command-incomplete
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=2
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG Screen .PNG"
	$PROGRAM $ARGS > $OUT 2>&1 || ERR=$?
	assertCommandFails $ERR $EXPECT "$PROGARM $ARGS"
	filter "$OUT"
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
	ARGS="$DEBUG --invalid Screen .PNE"
	$PROGRAM $ARGS 2>&1 | head -$HEAD > $OUT
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD command no matching files
TEST=command-nomatch
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=3
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG unknown-file .PNE renamed-"
	$PROGRAM $ARGS > $OUT 2>&1 || ERR=$?
	assertCommandFails $ERR $EXPECT "$PROGARM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

setup
echo TEST $CMD successful check operation
TEST=success-check
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG Screen .PNG snapshot 42"
	pushd $SAMPLE > /dev/null
	TEST=1 ../../$PROGRAM $ARGS > ../../$OUT 2>&1 || assertCommandSuccess $? "../../$PROGRAM $ARGS"
	popd > /dev/null
	echo "=== files on disk ======" >> $OUT
	find $SAMPLE | sort >> $OUT
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

setup
echo TEST $CMD successful operation
TEST=success
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG Screen .PNG renamed-"
	pushd $SAMPLE > /dev/null
	../../$PROGRAM $ARGS > ../../$OUT || assertCommandSuccess $? "../../$PROGRAM $ARGS"
	popd > /dev/null
	echo "=== files on disk ======" >> $OUT
	find $SAMPLE | sort >> $OUT
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

setup
echo TEST $CMD successful operation suffix
TEST=success-suffix
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG Screen .PNG renamed- 1 .png"
	pushd $SAMPLE > /dev/null
	../../$PROGRAM $ARGS > ../../$OUT 2>&1 || assertCommandSuccess $? "../../$PROGRAM $ARGS"
	popd > /dev/null
	echo "=== files on disk ======" >> $OUT
	find $SAMPLE | sort >> $OUT
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

setup
echo TEST $CMD successful operation overwrite existing
TEST=success-overwrite
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG Screen .PNG snapshot 41"
	pushd $SAMPLE > /dev/null
	../../$PROGRAM $ARGS > ../../$OUT 2>&1 || assertCommandSuccess $? "../../$PROGRAM $ARGS"
	popd > /dev/null
	echo "=== files on disk ======" >> $OUT
	find $SAMPLE | sort >> $OUT
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

[ -d $SAMPLE ] && rm -rf $SAMPLE
cleanUpAfterTests
