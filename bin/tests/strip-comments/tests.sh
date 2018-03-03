#!/bin/bash
# Shell script based test plan
# set -e gotchas http://mywiki.wooledge.org/BashFAQ/105
set -e

# What we're testing and sample input data
PROGRAM=../../strip-comments.pl
CMD=`basename $PROGRAM`
SAMPLE=in/top-comment1.txt
DEBUG=
SKIP=0

# Include testing library and make output dir exist
source ../shell-test.sh
PLAN 32

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
	assertCommandFails $ERR $EXPECT "$PROGARM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD command inplace and keep are incompatible
TEST=command-invalid-inplace-keep
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

echo TEST $CMD command inplace must have filename arguments
TEST=command-invalid-inplace-nofiles
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=1
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --inplace"
	$PROGRAM $ARGS 2>&1 | head -3 > $OUT
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD only comment block in file preserved - line comment
TEST=only-comment-line
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

SAMPLE=in/top-comment2.txt
echo TEST $CMD only comment block in file preserved - block comment - open file
TEST=only-comment-block
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG $SAMPLE"
	$PROGRAM $ARGS > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

SAMPLE=in/top-comment3.txt
echo TEST $CMD top comment block in file preserved - line comment
TEST=top-comment-line
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

SAMPLE=in/top-comment4.txt
echo TEST $CMD top comment block in file preserved - block comment
TEST=top-comment-block
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

SAMPLE=in/top-comment5.txt
echo TEST $CMD top comment block in file preserved - mixed comments
TEST=top-comment-mixed
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

SAMPLE=in/top-comment6.txt
echo TEST $CMD top comment block in file preserved - with eslint directive
TEST=top-comment-eslint
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

SAMPLE=in/top-comment7.txt
echo TEST $CMD top comment block in file preserved - with multiple directives
TEST=top-comment-directives
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

SAMPLE=in/top-comment8.txt
echo TEST $CMD no top comment present
TEST=top-comment-none
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

SAMPLE=in/top-comment9.txt
echo TEST $CMD directives and top comment and trailing directive
TEST=top-comment-directive-sandwich
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

SAMPLE=in/comments1.txt
echo TEST $CMD general test of stripping comments
TEST=comments-stripped
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

SAMPLE=in/comments1.txt
echo TEST $CMD strip comments in place with backup
TEST=strip-comments-inplace-backup
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	STDOUT=out/$TEST.stdout.out
	BASE=base/$TEST.base
	STDOUTBASE=base/$TEST.stdout.base
	ARGS="$DEBUG --inplace=.bak"
	cp $SAMPLE $OUT
	$PROGRAM $ARGS $OUT > $STDOUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	assertFilesEqual "$STDOUT" "$STDOUTBASE" "STDOUT $TEST"
	assertFilesEqual "$SAMPLE" "$OUT.bak" "BACKUP $TEST"
else
	echo SKIP $TEST "$SKIP"
fi

SAMPLE=in/comments1.txt
echo TEST $CMD strip comments in place without backup
TEST=strip-comments-inplace
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	STDOUT=out/$TEST.stdout.out
	BASE=base/$TEST.base
	STDOUTBASE=base/$TEST.stdout.base
	ARGS="$DEBUG --inplace"
	cp $SAMPLE $OUT
	$PROGRAM $ARGS $OUT > $STDOUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	assertFilesEqual "$STDOUT" "$STDOUTBASE" "STDOUT $TEST"
	assertFileMissing "$OUT.bak" "BACKUP $TEST"
else
	echo SKIP $TEST "$SKIP"
fi


SAMPLE=in/comments1.txt
echo TEST $CMD show comments which would be stripped
TEST=show-comments-stripped
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="--show $DEBUG"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

SAMPLE=in/comments1.txt
echo TEST $CMD show comments which would be kept
TEST=show-comments-kept
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="--keep $DEBUG"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

SAMPLE=in/comments1.txt
echo TEST $CMD show comments, keep all options
TEST=show-comments-kept-all
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="--keep --brace --eslint --jslint --jshint --jscs --istanbul --prettier $DEBUG"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

SAMPLE=in/comments1.txt
echo TEST $CMD show comments, keep none options
TEST=show-comments-kept-none
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="--keep --nobrace --noeslint --nojslint --nojshint --nojscs --noistanbul --noprettier --nojavadoc --javadoc=strip $DEBUG"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

SAMPLE=in/comments1.txt
echo TEST $CMD show comments, javadoc lite
TEST=show-comments-kept-javadoc-lite
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="--keep --javadoc=lite $DEBUG"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

SAMPLE=in/comments1.txt
echo TEST $CMD show comments, javadoc strict default
TEST=show-comments-kept-javadoc-strict
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="--keep --javadoc $DEBUG"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

SAMPLE=in/comments1.txt
echo TEST $CMD show comments, javadoc strict
TEST=show-comments-kept-javadoc-strict2
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="--keep --javadoc=strict $DEBUG"
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

cleanUpAfterTests
