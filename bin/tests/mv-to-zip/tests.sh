#!/bin/bash
# Shell script based test plan
# set -e gotchas http://mywiki.wooledge.org/BashFAQ/105
set -e

# What we're testing and sample input data
PROGRAM=../../mv-to-zip.sh
CMD=`basename $PROGRAM`
TAR=../../../rename-files/in/rename-files.tgz
SAMPLE=./out/tmp
DIR=xyzzy
DEBUG=
SKIP=0
HEAD=3

# Include testing library and make output dir exist
source ../shell-test.sh
PLAN 11

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
	pushd out > /dev/null
	[ -d tmp ] && rm -rf tmp
	mkdir tmp
	cd tmp
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

setup
echo TEST $CMD command error not a directory
TEST=command-error-dir
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=3
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG $DIR"
	pushd $SAMPLE > /dev/null
	rm -rf $DIR
	touch $DIR
	../../$PROGRAM $ARGS > ../../$OUT 2>&1 || ERR=$?
	assertCommandFails $ERR $EXPECT "../../$PROGRAM $ARGS"
	popd > /dev/null
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

setup
echo TEST $CMD command error archive exists
TEST=command-error-exists
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=2
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG $DIR"
	pushd $SAMPLE > /dev/null
	touch $DIR.zip
	../../$PROGRAM $ARGS > ../../$OUT 2>&1 || ERR=$?
	assertCommandFails $ERR $EXPECT "../../$PROGRAM $ARGS"
	popd > /dev/null
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
	ARGS="$DEBUG $DIR"
	pushd $SAMPLE > /dev/null
	../../$PROGRAM $ARGS > ../../$OUT || assertCommandSuccess $? "../../$PROGRAM $ARGS"
	echo "=== files on disk ======" >> ../../$OUT
	find . | sort >> ../../$OUT
	popd > /dev/null
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

[ -d $SAMPLE ] && rm -rf $SAMPLE
cleanUpAfterTests
