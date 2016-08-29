#!/bin/bash
# Shell script based test plan
# set -e gotchas http://mywiki.wooledge.org/BashFAQ/105
set -e

# What we're testing and sample input data
PROGRAM=../../ezbackup.sh
CMD=`basename $PROGRAM`
SAMPLE=in/source
DEBUG=--debug
DEBUG=
SKIP=0

# Include testing library and make output dir exist
source ../shell-test.sh
PLAN 4

[ -d out ] || mkdir out
rm out/* > /dev/null 2>&1 || OK "output dir ready"

# Do not terminate test plan if out/base comparison fails.
ERROR_STOP=0

function clean_output {
	local file
	file="$1"
	perl -i -pne '
		s{\w+ \s+ \w+ \s+ \d+ \s+ \d+:\d+:\d+ \s+ \w+ \s+ \d+}{Ddd Mmm DD HH:MM:SS Zzz YYYY}xmsg;
		s{\w+ \s+ \w+ \s+ \d+ \s+ \w+ \s+ \d+ \s+ \d+:\d+}{USER USER Nnn Mmm DD HH:MM}xmsg;
		' "$file"
}

echo TEST $CMD --help option
TEST=help-option
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --help"
	$PROGRAM $ARGS > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD initial full backup
TEST=init-full
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	BK_DIR=out/$TEST
	[ -d "$BK_DIR" ] && rm -rf "$BK_DIR"
	ARGS="$DEBUG partial $SAMPLE $BK_DIR"
	$PROGRAM $ARGS > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
	echo "==========" >> "$OUT"
	ls -1 $BK_DIR >> "$OUT"
	clean_output "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	assertFilesEqual "$BK_DIR/backup.log" "base/$TEST/backup.base" "$TEST backup"
	assertFilesEqual "$BK_DIR/stderr.log" "base/$TEST/stderr.base" "$TEST stderr"
	assertFilesEqual "$BK_DIR/errors.log" "base/$TEST/errors.base" "$TEST errors"
	assertFilesEqual "$BK_DIR/ignored-errors.log" "base/$TEST/ignored-errors.base" "$TEST ignored"
	assertFilesEqual "$BK_DIR/files.log" "base/$TEST/files.base" "$TEST files"
	assertFilesEqual "$BK_DIR/filenames.log" "base/$TEST/filenames.base" "$TEST filenames"
	assertFilesEqual "$BK_DIR/directories.log" "base/$TEST/directories.base" "$TEST directories"
else
	echo SKIP $TEST "$SKIP"
fi

#stop "simulating a failure so all output remains behind"

cleanUpAfterTests
