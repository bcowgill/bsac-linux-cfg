#!/bin/bash
# Shell script based test plan
# ./tests.sh | perl -pne 's{vdiff}{in.sh in diffmerge}xms'

# set -e gotchas http://mywiki.wooledge.org/BashFAQ/105
set -e

# What we're testing and sample input data
PROGRAM=../../../git-mv-src.sh
CMD=`basename $PROGRAM`
SAMPLE=src/X/Y/File.js
DEBUG=
#export DEBUG=1
#export DRY_RUN=1
SKIP=0

# Include testing library and make output dir exist
source ../shell-test.sh
PLAN 11

[ -d out ] || mkdir out
rm out/* > /dev/null 2>&1 || OK "output dir ready"

# Do not terminate test plan if out/base comparison fails.
ERROR_STOP=0

function show {
	local output file
	output="$1"
	touch "$output"
	for file in `find src -name '*.js' | sort`
	do
		if [ -d "$file" ]; then
			echo $file/: >> "$output"
		else
			echo $file: >> "$output"
			cat "$file" >> "$output"
		fi
	done
}

function setup {
	pushd in > /dev/null
	rm -rf src
	tar xzf source.tgz
	popd > /dev/null
}

echo TEST $CMD usage
TEST=usage
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=../out/$TEST.out
	BASE=../base/$TEST.base
	ARGS="$SAMPLE"
	setup
	pushd in > /dev/null
	MODE=mv $PROGRAM $ARGS > $OUT 2>&1 || assertCommandFails $? 1 "$PROGRAM $ARGS"
	show $OUT
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	popd > /dev/null
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD move down
TEST=move-down
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=../out/$TEST.out
	BASE=../base/$TEST.base
	ARGS="$SAMPLE src/X/Y/W"
	setup
	pushd in > /dev/null
	MODE=mv $PROGRAM $ARGS > $OUT 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	show $OUT
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	popd > /dev/null
else
	echo SKIP $TEST "$SKIP"
fi
# manually run test with debug
# pushd in; tar xf source.tgz; MODE=mv git-mv-src.sh src/X/Y/File.js src/X/Y/W

echo TEST $CMD move up
TEST=move-up
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=../out/$TEST.out
	BASE=../base/$TEST.base
	ARGS="$SAMPLE src/X"
	setup
	pushd in > /dev/null
	MODE=mv $PROGRAM $ARGS > $OUT 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	show $OUT
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	popd > /dev/null
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD move over
TEST=move-over
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=../out/$TEST.out
	BASE=../base/$TEST.base
	ARGS="$SAMPLE src/X/W"
	setup
	pushd in > /dev/null
	MODE=mv $PROGRAM $ARGS > $OUT 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	show $OUT
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	popd > /dev/null
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD move up over down
TEST=move-up-over-down
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=../out/$TEST.out
	BASE=../base/$TEST.base
	ARGS="$SAMPLE src/X/W/A"
	setup
	pushd in > /dev/null
	MODE=mv $PROGRAM $ARGS > $OUT 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	show $OUT
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	popd > /dev/null
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD move up up over
TEST=up-up-over
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=../out/$TEST.out
	BASE=../base/$TEST.base
	ARGS="$SAMPLE src/Z"
	setup
	pushd in > /dev/null
	MODE=mv $PROGRAM $ARGS > $OUT 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	show $OUT
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	popd > /dev/null
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD move almost index
TEST=index-almost
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=../out/$TEST.out
	BASE=../base/$TEST.base
	ARGS="$SAMPLE src/Z/File"
	setup
	pushd in > /dev/null
	MODE=mv $PROGRAM $ARGS > $OUT 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	show $OUT
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	popd > /dev/null
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD move with index.js
TEST=index-move
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=../out/$TEST.out
	BASE=../base/$TEST.base
	ARGS="$SAMPLE src/Z/File index.js"
	setup
	pushd in > /dev/null
	MODE=mv $PROGRAM $ARGS > $OUT 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	show $OUT
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	popd > /dev/null
else
	echo SKIP $TEST "$SKIP"
fi

#stop "simulating a failure so all .html output remains behind for front end behaviour verification"

setup
rm in/moved.lst
rm in/pause-build.timestamp
cleanUpAfterTests
