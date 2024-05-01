#!/bin/bash
# Shell script based test plan
# set -e gotchas http://mywiki.wooledge.org/BashFAQ/105
set -e

# What we're testing and sample input data
PROGRAM=../../get-meta.sh
CMD=`basename $PROGRAM`
SAMPLE=in/TestId3Tagv2basic.mp3
SAMPLE2=out/TestId3Tagv2basic.mp3
DEBUG=
SKIP=0
HEAD=3

# Include testing library and make output dir exist
source ../shell-test.sh
PLAN 11

[ -d out ] || mkdir out
rm out/* > /dev/null 2>&1 || OK "output dir ready"

cp $SAMPLE $SAMPLE2

COMMENT1="DESC:Comment with description"
COMMENT2="DESC:Commentaire avec description et langue:fre"

id3v2 --artist="THE_ARTIST" \
	--album="THE_ALBUM" \
	--song="THE_SONG" \
	--comment="THE_COMMENT" \
	--comment=":THE_COMMENT2:" \
	--comment="$COMMENT1" \
	--comment="$COMMENT2" \
	--genre="42" \
	--year="2102" \
	--track="13" \
	$SAMPLE2

# Do not terminate test plan if out/base comparison fails.
ERROR_STOP=0

# Filter an output file to remove changing text like dates, etc...
function filter {
	local file
	file="$1"
	perl -i -pne 's{DONOTFILTER\w+\s+\(\w+\)}{NAME (ROLE)}xms' $file
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

echo TEST $CMD successful operation
TEST=success
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$PROGRAM $ARGS $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful operation secondary
TEST=success-secondary
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$PROGRAM $ARGS $SAMPLE $SAMPLE2 > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful operation with fields
TEST=success-fields
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	FIELDS="TCON|TRCK" $PROGRAM $ARGS $SAMPLE $SAMPLE2 > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful operation with values only
TEST=success-values
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	VALUES=1 FIELDS="TIT2" $PROGRAM $ARGS $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful operation with values only
TEST=success-values2
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	VALUES=2 FIELDS="TIT2" $PROGRAM $ARGS $SAMPLE > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

cleanUpAfterTests
