#!/bin/bash
# Shell script based test plan
# set -e gotchas http://mywiki.wooledge.org/BashFAQ/105
set -e

# What we're testing and sample input data
PROGRAM=../../see.sh
NOLAUNCH="../../see.sh --test"
CMD=`basename $PROGRAM`
SAMPLE=in/text.txt
DIR=in
DEBUG=
SKIP=0

# Include testing library and make output dir exist
source ../shell-test.sh
PLAN 31

[ -d out ] || mkdir out
rm out/* > /dev/null 2>&1 || OK "output dir ready"

# Do not terminate test plan if out/base comparison fails.
ERROR_STOP=0

# Filter an output file to remove changing text like dates, etc...
function filter {
	local file
	file="$1"
	# me me 24 Jan 30 13:13
	# /tmp/favicon.ico.b1SMZn.ppm
	perl -i -pne '
		s{me\s+me.+?(\d+:\d+)}{me me DATE HH:MM}xms;
		s{(/tmp/.+?)\.[^.]+\.(ppm)}{$1.XXXXXX.$2}xms;
	' $file
}

echo TEST $CMD command help
TEST=command-help
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --help $SAMPLE"
	$NOLAUNCH $ARGS > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
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
	$NOLAUNCH $ARGS > $OUT 2>&1 || ERR=$?
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

echo TEST $CMD successful show 19
TEST=success-show-19
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$PROGRAM $ARGS $DIR/text-19-lines.txt > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful show 20
TEST=success-show-20
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$PROGRAM $ARGS $DIR/text-20-lines.txt > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful show 21
TEST=success-show-21-less
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$NOLAUNCH $ARGS $DIR/text-21-lines.txt > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD successful binary 21
TEST=success-binary
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$PROGRAM $ARGS $DIR/binary-ssid-executable > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

# bzip2 archive-bzip2.txt
echo TEST $CMD successful archive1 bzip2
TEST=success-archive-bzip2
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$NOLAUNCH $ARGS $DIR/archive-bzip2.txt.bz2 > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

# tar cvf archive.tar.xz --xz text.txt
echo TEST $CMD successful archive2 xz
TEST=success-archive-xz
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$NOLAUNCH $ARGS $DIR/archive.tar.xz > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

# echo text.txt | cpio --create > archive.cpio
echo TEST $CMD successful archive3 cpio
TEST=success-archive-cpio
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$NOLAUNCH $ARGS $DIR/archive.cpio > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

# ar r archive.ar text.txt
echo TEST $CMD successful archive4 ar
TEST=success-archive-ar
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$NOLAUNCH $ARGS $DIR/archive.ar > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

# tar cf archive.tar text.txt
echo TEST $CMD successful archive5 tar
TEST=success-archive-tar
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$NOLAUNCH $ARGS $DIR/archive.tar > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP";
fi

# tar czf archive.tar.gz text.txt
echo TEST $CMD successful archive6 tar.gz
TEST=success-archive-tar-gz
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$NOLAUNCH $ARGS $DIR/archive.tar.gz > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP";
fi

# tar czf archive.tgz text.txt
echo TEST $CMD successful archive7 tgz
TEST=success-archive-tgz
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$NOLAUNCH $ARGS $DIR/archive.tgz > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP";
fi

# gz archive-gz.txt
echo TEST $CMD successful archive8 gzip
TEST=success-archive-gzip
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$NOLAUNCH $ARGS $DIR/archive-gz.txt.gz > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP";
fi

# zip archive.zip text.txt
echo TEST $CMD successful archive9 zip
TEST=success-archive-zip
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$NOLAUNCH $ARGS $DIR/archive.zip > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP";
fi

echo TEST $CMD successful archive debian package
TEST=success-archive-deb
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$NOLAUNCH $ARGS $DIR/debian-package.deb > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP";
fi

echo TEST $CMD successful xml
TEST=success-xml
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$NOLAUNCH $ARGS $DIR/xml.xml > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP";
fi

echo TEST $CMD successful xml sgml
TEST=success-xml-sgml
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$NOLAUNCH $ARGS $DIR/sgml.xml > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP";
fi

echo TEST $CMD successful xml document docbook
TEST=success-xml-docbook
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$NOLAUNCH $ARGS $DIR/document-docbook.xml > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP";
fi

echo TEST $CMD successful xml document word
TEST=success-xml-word
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$NOLAUNCH $ARGS $DIR/document-word-2003-xml.xml > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP";
fi

echo TEST $CMD successful extension csv
TEST=success-ext-csv
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$NOLAUNCH $ARGS $DIR/csv.csv > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP";
fi

echo TEST $CMD successful extension spreadsheets
TEST=success-ext-spreadsheets
SPREAD=`ls $DIR/spreadsheet*.* | grep -vE '\.xml' | sort`
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$NOLAUNCH $ARGS $SPREAD > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP";
fi

echo TEST $CMD successful extension documents
TEST=success-ext-documents
DOCS=`ls $DIR/document*.* | grep -vE '\.xml' | sort`
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$NOLAUNCH $ARGS $DOCS > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP";
fi

echo TEST $CMD successful images
TEST=success-images
PICS=`ls ../../template/img/*.* | grep -vE '\.txt|\.sh' | sort`

if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	$NOLAUNCH $ARGS $PICS > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP";
fi

echo TEST $CMD successful audio
TEST=success-audio
SNDS=`ls ../../sounds/*.* | grep -vE '\.txt|\.sh' | sort`

#echo SNDS=$SNDS

if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	#echo $NOLAUNCH $ARGS $SNDS
	$NOLAUNCH $ARGS $SNDS > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP";
fi

echo TEST $CMD successful video
TEST=success-video
VIDS=`ls ../../template/video/*.* | grep -vE '\.txt|\.sh' | sort`

#echo SNDS=$SNDS

if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG"
	#echo $NOLAUNCH $ARGS $SNDS
	$NOLAUNCH $ARGS $VIDS > $OUT || assertCommandSuccess $? "$PROGRAM $ARGS"
	filter "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP";
fi

cleanUpAfterTests
