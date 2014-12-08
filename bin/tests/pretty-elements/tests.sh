#!/bin/bash
# Shell script based test plan
# set -e gotchas http://mywiki.wooledge.org/BashFAQ/105
set -e

# What we're testing and sample input data
PROGRAM=../../pretty-elements.pl
SAMPLE=in/sample-html-elements.txt
DEBUG=--debug
DEBUG=
SKIP=0

# Include testing library and make output dir exist
source ../shell-test.sh
PLAN 13

[ -d out ] || mkdir out
rm out/* > /dev/null 2>&1 || OK "output dir ready"

# Do not terminate test plan if out/base comparison fails.
ERROR_STOP=0

echo TEST --version option
TEST=version-option
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --version"
	$PROGRAM $ARGS > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	perl -i -pne 's{version \s+ [\d\.]+}{version X.XX}xmsg' "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST unknown option
TEST=unknown-option
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=1
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --unknown-option"
	$PROGRAM $ARGS > $OUT 2>&1 || ERR=$?
	assertCommandFails $ERR $EXPECT "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST --man option
TEST=man-option
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --man"
	$PROGRAM $ARGS > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	perl -i -pne 's{(perl \s+ v)[\d\.]+(\s+\d{4}-\d{2}-\d{2})}{${1}X.XX$2}xms; s{\d\d\d\d-\d\d-\d\d}{YYYY-MM-DD}xms' "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST scanning for elements
TEST=scan-elements
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG $SAMPLE"
	$PROGRAM $ARGS > $OUT 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	perl -i -pne 's{(pl \s+ line \s+) \d+}{${1}NNNN}xms' "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST inplace edit of elements
TEST=edit-elements
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --edit $OUT"
	cp $SAMPLE $OUT
	chmod +w $OUT
	$PROGRAM $ARGS > $OUT.warn 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	perl -i -pne 's{(pl \s+ line \s+) \d+}{${1}NNNN}xms' "$OUT.warn"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	assertFilesEqual "$OUT.warn" "$BASE.warn" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST inplace edit of a template
TEST=edit-template
SAMPLE=in/campaign_details.tt
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --edit $OUT"
	cp $SAMPLE $OUT
	chmod +w $OUT
	$PROGRAM $ARGS > $OUT.warn 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	perl -i -pne 's{(pl \s+ line \s+) \d+}{${1}NNNN}xms' "$OUT.warn"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	assertFilesEqual "$OUT.warn" "$BASE.warn" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST scanning for complex elements
TEST=scan-complex
SAMPLE=in/complex.txt
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG $SAMPLE"
	$PROGRAM $ARGS > $OUT 2>&1 || assertCommandSuccess $? "$PROGRAM $ARGS"
	perl -i -pne 's{(pl \s+ line \s+) \d+}{${1}NNNN}xms' "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

cleanUpAfterTests

