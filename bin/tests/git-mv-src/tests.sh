#!/bin/bash
# Shell script based test plan
# set -e gotchas http://mywiki.wooledge.org/BashFAQ/105
set -e

# What we're testing and sample input data
PROGRAM=../../../git-mv-src.sh
CMD=`basename $PROGRAM`
SAMPLE=src/X/Y/File.js
DEBUG=--debug
DEBUG=
SKIP=0

# Include testing library and make output dir exist
source ../shell-test.sh
PLAN 6

[ -d out ] || mkdir out
rm out/* > /dev/null 2>&1 || OK "output dir ready"

# Do not terminate test plan if out/base comparison fails.
ERROR_STOP=0

function show {
	local output file
	output="$1"
	[ -f "$output" ] && rm "$output"
	touch "$output"
	for file in `find src -name *.js`
	do
		echo $file: >> "$output"
		cat $file >> "$output"
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
	OUT2=../out/$TEST-tree.out
	BASE=../base/$TEST.base
	BASE2=../base/$TEST-tree.base
	ARGS="$DEBUG $SAMPLE"
	setup
	pushd in > /dev/null
	MODE=mv $PROGRAM $ARGS > $OUT 2>&1 || assertCommandFails $? 1 "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	show $OUT2
	assertFilesEqual "$OUT2" "$BASE2" "$TEST"
	popd > /dev/null
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD simple move
TEST=simple-move
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=../out/$TEST.out
	OUT2=../out/$TEST-tree.out
	BASE=../base/$TEST.base
	BASE2=../base/$TEST-tree.base
	ARGS="$DEBUG $SAMPLE src/Z"
	setup
	pushd in > /dev/null
	MODE=mv $PROGRAM $ARGS > $OUT 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	show $OUT2
	assertFilesEqual "$OUT2" "$BASE2" "$TEST"
	popd > /dev/null
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD move with index.js
TEST=index-move
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=../out/$TEST.out
	OUT2=../out/$TEST-tree.out
	BASE=../base/$TEST.base
	BASE2=../base/$TEST-tree.base
	ARGS="$DEBUG $SAMPLE src/Z/File/index.js"
	setup
	pushd in > /dev/null
	MODE=mv $PROGRAM $ARGS > $OUT 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	show $OUT2
	assertFilesEqual "$OUT2" "$BASE2" "$TEST"
	popd > /dev/null
else
	echo SKIP $TEST "$SKIP"
fi

#stop "simulating a failure so all .html output remains behind for front end behaviour verification"

setup
cleanUpAfterTests
