#!/bin/bash
# Shell script based test plan
# set -e gotchas http://mywiki.wooledge.org/BashFAQ/105
set -e

# What we're testing and sample input data
NODE_VER=${1:-0.10.0}
NODE=`echo n use $NODE_VER | perl -pne 's{n \s+ use \s+ ([123]\.0\.0)}{n io use $1}xmsg'`
PROGRAM="../../lint-package-json.js"
CMD=`basename $PROGRAM`
PROGRAM="$NODE $PROGRAM"
SAMPLE=in/package-test.json
DEBUG=
SKIP=0

# Include testing library and make output dir exist
source ../shell-test.sh
PLAN 25

[ -d out ] || mkdir out
rm out/* > /dev/null 2>&1 || OK "output dir ready"

# Do not terminate test plan if out/base comparison fails.
ERROR_STOP=0

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

echo TEST $CMD command file not found
TEST=command-missing-file-$NODE_VER
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=2
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG notafilename"
	$PROGRAM $ARGS > $OUT 2>&1 || ERR=$?
	assertCommandFails $ERR $EXPECT "$PROGRAM $ARGS"
	perl -i -pne 's{(current \s+ dir \s+).+(lint-package-json)}{$1PWD/$2}xms' "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD command syntax error in package.json
TEST=command-invalid-package-json-$NODE_VER
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=5
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG in/package-error.json"
	$PROGRAM $ARGS > $OUT 2>&1 || ERR=$?
	assertCommandFails $ERR $EXPECT "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD lint errors all
TEST=command-lint-errors-all
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=4
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG $SAMPLE"
	$PROGRAM $ARGS > $OUT 2>&1 || ERR=$?
	assertCommandFails $ERR $EXPECT "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD lint errors skip dev
TEST=command-lint-errors-skip-dev
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=4
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG $SAMPLE --skip-dev"
	$PROGRAM $ARGS > $OUT 2>&1 || ERR=$?
	assertCommandFails $ERR $EXPECT "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD lint errors allow url
TEST=command-lint-errors-allow-url
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=4
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG in/package-ok.json --allow-url"
	$PROGRAM $ARGS > $OUT 2>&1 || ERR=$?
	assertCommandFails $ERR $EXPECT "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD lint errors allow file
TEST=command-lint-errors-allow-file
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=4
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG in/package-ok.json --allow-file"
	$PROGRAM $ARGS > $OUT 2>&1 || ERR=$?
	assertCommandFails $ERR $EXPECT "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD lint erros allow git
TEST=command-lint-errors-allow-git
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=4
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG in/package-ok.json --allow-git"
	$PROGRAM $ARGS > $OUT 2>&1 || ERR=$?
	assertCommandFails $ERR $EXPECT "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD lint erros allow github
TEST=command-lint-errors-allow-github
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=4
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG in/package-ok.json --allow-github"
	$PROGRAM $ARGS > $OUT 2>&1 || ERR=$?
	assertCommandFails $ERR $EXPECT "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD lint erros allow tag
TEST=command-lint-errors-allow-tag
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=4
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG in/package-ok.json --allow-tag=beta1 --allow-tag=latest"
	$PROGRAM $ARGS > $OUT 2>&1 || ERR=$?
	assertCommandFails $ERR $EXPECT "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful operation no strict
TEST=lint-ok-no-strict
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG in/package-ok.json --no-strict --allow-url --allow-file --allow-git --allow-github"
	$PROGRAM $ARGS > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

cleanUpAfterTests
