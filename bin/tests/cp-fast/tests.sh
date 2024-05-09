#!/bin/bash
# Shell script based test plan
# set -e gotchas http://mywiki.wooledge.org/BashFAQ/105
set -e

# What we're testing and sample input data
PROGRAM=../../cp-fast.sh
CMD=`basename $PROGRAM`
TAR=../../../rename-files/in/rename-files.tgz
SAMPLE=./out/tmp
DIR=xyzzy
NEW=zyyxz
HUGE=a-simulated-huge-file.txt
DEBUG=
SKIP=0
HEAD=3

# Include testing library and make output dir exist
source ../shell-test.sh
PLAN 17

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
	$PROGRAM $ARGS 2>&1 > $OUT || ERR=$?
	assertCommandFails $ERR $EXPECT "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD command no source
TEST=command-invalid-no-source
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$PROGRAM $ARGS 2>&1 | head -$HEAD > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
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
echo TEST $CMD command error target not there
TEST=command-error-no-target-there
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=4
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG $DIR $NEW"
	pushd $SAMPLE > /dev/null
	../../$PROGRAM $ARGS > ../../$OUT 2>&1 || ERR=$?
	assertCommandFails $ERR $EXPECT "../../$PROGRAM $ARGS"
	popd > /dev/null
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

setup
echo TEST $CMD command error source not there
TEST=command-error-no-source-there
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=5
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG $HUGE $NEW"
	pushd $SAMPLE > /dev/null
	mkdir $NEW
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
	ARGS="$DEBUG $DIR $NEW"
	pushd $SAMPLE > /dev/null
	mkdir $NEW
	../../$PROGRAM $ARGS > ../../$OUT 2> /dev/null || assertCommandSuccess $? "../../$PROGRAM $ARGS"
	echo "=== files on disk ======" >> ../../$OUT
	find . | sort >> ../../$OUT
	popd > /dev/null
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

setup
echo TEST $CMD successful operation new dir
TEST=success-new-dir
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG $DIR $NEW new-dir"
	pushd $SAMPLE > /dev/null
	mkdir $NEW
	../../$PROGRAM $ARGS > ../../$OUT 2> /dev/null || assertCommandSuccess $? "../../$PROGRAM $ARGS"
	echo "=== files on disk ======" >> ../../$OUT
	find . | sort >> ../../$OUT
	popd > /dev/null
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

setup
echo TEST $CMD successful operation huge file
TEST=success-huge-file
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG $HUGE $NEW"
	pushd $SAMPLE > /dev/null
	mkdir $NEW
	rm -rf $DIR
	touch $HUGE
	../../$PROGRAM $ARGS > ../../$OUT 2> /dev/null || assertCommandSuccess $? "../../$PROGRAM $ARGS"
	echo "=== files on disk ======" >> ../../$OUT
	find . | sort >> ../../$OUT
	popd > /dev/null
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi
setup
echo TEST $CMD successful operation huge file new dir
TEST=success-huge-file-new-dir
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG $HUGE $NEW new-dir"
	pushd $SAMPLE > /dev/null
	mkdir $NEW
	rm -rf $DIR
	touch $HUGE
	../../$PROGRAM $ARGS > ../../$OUT 2> /dev/null || assertCommandSuccess $? "../../$PROGRAM $ARGS"
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
