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
HEAD=3

# Include testing library and make output dir exist
source ../shell-test.sh
PLAN 66

[ -d out ] || mkdir out
rm out/* > /dev/null 2>&1 || OK "output dir ready"

# Do not terminate test plan if out/base comparison fails.
ERROR_STOP=0

function clean_output {
	local file
	file="$1"

	perl -MCwd -i -pne '
      $cwd = $cwd || cwd();
		s{\w+ \s+ \w+ \s+ \d+ \s+ \d+:\d+:\d+ \s+ \w+ \s+ \d+}{Ddd Mmm DD HH:MM:SS Zzz YYYY}xmsg;
		s{\w+ \s+ \w+ \s+ \d+ \s+ \w+ \s+ \d+ \s+ \d+:\d+}{USER USER Nnn Mmm DD HH:MM}xmsg;
		s{\A / .+? \d+(\% \s+ / \s*) \z}{/device  NnnG  NnnG  NnnG  Nn$1}xmsg;
		s{$cwd}{HOME/TESTS/}xmsg;
		' "$file"
}

function setup_warning {
	touch $HOME/warnings.log
	if [ `cat $HOME/warnings.log | wc -l` != 0 ]; then
		NOT_OK "$HOME/warnings.log already contains warnings!"
	fi
	cp $HOME/warnings.log out/warnings.log
}

function restore_warning {
	cp $HOME/warnings.log out/$TEST/warnings.log 2> /dev/null && clean_output "out/$TEST/warnings.log"
	cp out/warnings.log $HOME/warnings.log
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

echo TEST $CMD source must exist
TEST=error-source
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	BK_DIR=./out/$TEST
	[ -d "$BK_DIR" ] && rm -rf "$BK_DIR"
	ARGS="$DEBUG partial $SAMPLE/doesnotexist $BK_DIR"
	setup_warning
	$PROGRAM $ARGS 2>&1 | head -$HEAD > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
	restore_warning
	clean_output "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD unable to create backup dir
TEST=error-destination
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	BK_DIR=/doesnotexistpermissiondenied
	ARGS="$DEBUG partial $SAMPLE $BK_DIR"
	setup_warning
	$PROGRAM $ARGS 2>&1 | head -$HEAD > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
	clean_output "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD debug option
TEST=debug
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	BK_DIR=./out/$TEST
	[ -d "$BK_DIR" ] && rm -rf "$BK_DIR"
	ARGS="--debug partial $SAMPLE $BK_DIR"
	setup_warning
	$PROGRAM $ARGS > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
	restore_warning
	clean_output "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD forces initial full backup
TEST=init-full
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	BK_DIR=./out/$TEST
	[ -d "$BK_DIR" ] && rm -rf "$BK_DIR"
	ARGS="$DEBUG partial $SAMPLE $BK_DIR"
	setup_warning
	$PROGRAM $ARGS > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
	restore_warning
	echo "==========" >> "$OUT"
	ls -1 $BK_DIR >> "$OUT"
	clean_output "$OUT"
	clean_output "$BK_DIR/say.log"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	assertFilesEqual "$BK_DIR/say.log" "base/$TEST/say.base" "$TEST say"
	assertFilesEqual "out/$TEST/warnings.log" "base/$TEST/warnings.base" "$TEST home warning"
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

echo TEST $CMD external disk missing partial cannot proceed
TEST=error-external-unmounted
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	BK_DIR=./out/$TEST/ezbackup
	BK_DISK=./out/$TEST/external
	[ -d "$BK_DIR" ] && rm -rf "$BK_DIR"
	ARGS="$DEBUG partial $SAMPLE $BK_DIR $BK_DISK"
	setup_warning
	$PROGRAM $ARGS > "$OUT" || assertCommandFails $? 2 "$PROGRAM $ARGS"
	restore_warning
	echo "==========" >> "$OUT"
	ls -1 $BK_DIR >> "$OUT"
	clean_output "$OUT"
	clean_output "$BK_DIR/say.log"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	assertFilesEqual "$BK_DIR/say.log" "base/$TEST/say.base" "$TEST say"
	assertFilesEqual "out/$TEST/warnings.log" "base/$TEST/warnings.base" "$TEST home warning"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD external disk unmounted cannot do full backup
TEST=error-external-unmounted-full
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	BK_DIR=./out/$TEST/ezbackup
	BK_DISK=./out/$TEST/external
	[ -d "$BK_DIR" ] && rm -rf "$BK_DIR"
	ARGS="$DEBUG full $SAMPLE $BK_DIR $BK_DISK"
	setup_warning
	$PROGRAM $ARGS > "$OUT" || assertCommandFails $? 2 "$PROGRAM $ARGS"
	restore_warning
	echo "==========" >> "$OUT"
	ls -1 $BK_DIR >> "$OUT"
	clean_output "$OUT"
	clean_output "$BK_DIR/say.log"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	assertFilesEqual "$BK_DIR/say.log" "base/$TEST/say.base" "$TEST say"
	assertFilesEqual "out/$TEST/warnings.log" "base/$TEST/warnings.base" "$TEST home warning"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD external disk unmounted with old full backup does a partial backup
TEST=error-external-unmounted-is-old
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	BK_DIR=./out/$TEST/ezbackup
	BK_DISK=./out/$TEST/external
	[ -d "$BK_DIR" ] && rm -rf "$BK_DIR"
	ARGS="$DEBUG full $SAMPLE $BK_DIR $BK_DISK"
	# set up full and partial backups
	mkdir -p $BK_DIR
	touch "$BK_DIR/full-backup.timestamp"
	for backup in 1 2 3 4 5; do
		touch "$BK_DIR/ezbackup.$backup.tgz"
	done
	touch "$BK_DIR/partial.5.timestamp"
	sleep 1;
	touch "$SAMPLE/2.txt"
	setup_warning
	$PROGRAM $ARGS > "$OUT" || assertCommandFails $? 2 "$PROGRAM $ARGS"
	restore_warning
	echo "==========" >> "$OUT"
	ls -1 $BK_DIR >> "$OUT"
	clean_output "$OUT"
	clean_output "$BK_DIR/say.log"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	assertFilesEqual "$BK_DIR/say.log" "base/$TEST/say.base" "$TEST say"
	assertFilesEqual "out/$TEST/warnings.log" "base/$TEST/warnings.base" "$TEST home warning"
	assertFilesEqual "$BK_DIR/backup.6.log" "base/$TEST/backup.base" "$TEST backup"
	assertFilesEqual "$BK_DIR/stderr.6.log" "base/$TEST/stderr.base" "$TEST stderr"
	assertFilesEqual "$BK_DIR/errors.6.log" "base/$TEST/errors.base" "$TEST errors"
	assertFilesEqual "$BK_DIR/ignored-errors.6.log" "base/$TEST/ignored-errors.base" "$TEST ignored"
	assertFilesEqual "$BK_DIR/files.6.log" "base/$TEST/files.base" "$TEST files"
	assertFilesEqual "$BK_DIR/filenames.6.log" "base/$TEST/filenames.base" "$TEST filenames"
	assertFilesEqual "$BK_DIR/directories.6.log" "base/$TEST/directories.base" "$TEST directories"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD simple backup does partial
TEST=simple-partial
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	BK_DIR=./out/$TEST
	[ -d "$BK_DIR" ] && rm -rf "$BK_DIR"
	ARGS="$DEBUG partial $SAMPLE $BK_DIR"
	# set up full backup
	mkdir -p $BK_DIR
	touch "$BK_DIR/full-backup.timestamp"
	touch "$BK_DIR/ezbackup.tgz"
	sleep 1;
	touch "$SAMPLE/1.txt"
	setup_warning
	$PROGRAM $ARGS > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
	restore_warning
	echo "==========" >> "$OUT"
	ls -1 $BK_DIR >> "$OUT"
	clean_output "$OUT"
	clean_output "$BK_DIR/say.log"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	assertFilesEqual "$BK_DIR/say.log" "base/$TEST/say.base" "$TEST say"
	assertFilesEqual "out/$TEST/warnings.log" "base/$TEST/warnings.base" "$TEST home warning"
	assertFilesEqual "$BK_DIR/backup.1.log" "base/$TEST/backup.base" "$TEST backup"
	assertFilesEqual "$BK_DIR/stderr.1.log" "base/$TEST/stderr.base" "$TEST stderr"
	assertFilesEqual "$BK_DIR/errors.1.log" "base/$TEST/errors.base" "$TEST errors"
	assertFilesEqual "$BK_DIR/ignored-errors.1.log" "base/$TEST/ignored-errors.base" "$TEST ignored"
	assertFilesEqual "$BK_DIR/files.1.log" "base/$TEST/files.base" "$TEST files"
	assertFilesEqual "$BK_DIR/filenames.1.log" "base/$TEST/filenames.base" "$TEST filenames"
	assertFilesEqual "$BK_DIR/directories.1.log" "base/$TEST/directories.base" "$TEST directories"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD simple backup forces full when all partials done
TEST=simple-force-full
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	BK_DIR=./out/$TEST
	[ -d "$BK_DIR" ] && rm -rf "$BK_DIR"
	ARGS="$DEBUG partial $SAMPLE $BK_DIR"
	# set up full and partial backups
	mkdir -p $BK_DIR
	touch "$BK_DIR/full-backup.timestamp"
	for backup in 1 2 3 4 5; do
		touch "$BK_DIR/ezbackup.$backup.tgz"
	done
	touch "$BK_DIR/partial.5.timestamp"
	sleep 1;
	touch "$SAMPLE/1.txt"
	setup_warning
	$PROGRAM $ARGS > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
	restore_warning
	echo "==========" >> "$OUT"
	ls -1 $BK_DIR >> "$OUT"
	clean_output "$OUT"
	clean_output "$BK_DIR/say.log"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	assertFilesEqual "$BK_DIR/say.log" "base/$TEST/say.base" "$TEST say"
	assertFilesEqual "out/$TEST/warnings.log" "base/$TEST/warnings.base" "$TEST home warning"
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

echo TEST $CMD full external backup
TEST=full-external
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	BK_DIR=./out/$TEST/ezbackup
	BK_DISK=./out/$TEST/external
	[ -d "$BK_DIR" ] && rm -rf "$BK_DIR"
	[ -d "$BK_DISK" ] && rm -rf "$BK_DISK"
	mkdir -p "$BK_DISK"
	ARGS="$DEBUG full $SAMPLE $BK_DIR $BK_DISK"
	setup_warning
	$PROGRAM $ARGS > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
	restore_warning
	echo "==========" >> "$OUT"
	ls -1 $BK_DIR >> "$OUT"
	clean_output "$OUT"
	clean_output "$BK_DIR/say.log"
	clean_output "$BK_DISK/summary.log"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
	assertFilesEqual "$BK_DIR/say.log" "base/$TEST/say.base" "$TEST say"
	assertFilesEqual "out/$TEST/warnings.log" "base/$TEST/warnings.base" "$TEST home warning"
	assertFilesEqual "$BK_DISK/summary.log" "base/$TEST/summary.base" "$TEST external summary"
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
