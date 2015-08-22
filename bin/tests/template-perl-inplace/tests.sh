#!/bin/bash
# Shell script based test plan
# set -e gotchas http://mywiki.wooledge.org/BashFAQ/105
set -e

# What we're testing and sample input data
PROGRAM=../../template/perl/perl-inplace.pl
CMD=`basename $PROGRAM`
SAMPLE=in/sample.txt
DEBUG=--debug
DEBUG=
SKIP=0
MANDATORY="--length=42 --hex=0x3c7e --file=filename --name=name --map key=value"


# Include testing library and make output dir exist
source ../shell-test.sh
PLAN 12

[ -d out ] || mkdir out
rm out/* > /dev/null 2>&1 || OK "output dir ready"

# Do not terminate test plan if out/base comparison fails.
ERROR_STOP=0

echo TEST $CMD --version option
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

echo TEST $CMD unknown option
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

echo TEST $CMD --man option
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

echo TEST $CMD stdin operation
TEST=stdin
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG $MANDATORY"
#	echo $PROGRAM $ARGS from $SAMPLE to $OUT
	$PROGRAM $ARGS < $SAMPLE > $OUT || assertCommandFails $? 1 "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD filename operation
TEST=filename
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG $SAMPLE $MANDATORY"
	$PROGRAM $ARGS > $OUT || assertCommandFails $? 1 "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD editing operation
TEST=edit
SAMPLE=in/sample.txt
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --splat=$OUT $MANDATORY"
	cp $SAMPLE $OUT
#	echo $PROGRAM $ARGS
	$PROGRAM $ARGS > $OUT.stdout || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	assertFilesEqual "$OUT.stdout" "$BASE.stdout" "$TEST stdout correct"
	assertFilesEqual "$OUT.bak" "$SAMPLE" "$TEST backup kept"
else
	echo SKIP $TEST "$SKIP"
fi

cleanUpAfterTests

