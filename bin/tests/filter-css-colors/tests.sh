#!/bin/bash
# Shell script based test plan
# set -e gotchas http://mywiki.wooledge.org/BashFAQ/105
set -e

# What we're testing and sample input data
PROGRAM=../../filter-css-colors.pl
CMD=`basename $PROGRAM`
SAMPLE=in/filter-css-colors-test.txt
SAMPLE_REMAP=in/remap-sample.txt
SAMPLE_RULE_PARAMS=in/rule-parameters.less
EMPTY=in/empty.txt
VARS=in/vars-sample.txt
DEBUG=--debug
DEBUG=
LINES=5
SKIP=0

MANUAL_CONST="--const=bg=#345 --const=fg=black \
	--const=border=@fg --const=shade=grey \
	--const=rg1=rgba(1,2,3,0.5) --const=rg2=rgb(12,13,14) \
	--const=hs1=hsla(32,45%,23%,0.3) --const=hs2=hsl(34,23%,67%)"

# Include testing library and make output dir exist
source ../shell-test.sh
PLAN 44

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
	$PROGRAM $ARGS > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
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
	$PROGRAM $ARGS > "$OUT" 2>&1 || ERR=$?
	assertCommandFails $ERR $EXPECT "$PROGRAM $ARGS"
	assertFileHeadersEqual $LINES "$OUT" "$BASE" "$TEST"
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
	$PROGRAM $ARGS | filter-man.pl > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
	perl -i -pne 's{(perl \s+ v)[\d\.]+(\s+\d{4}-\d{2}-\d{2})}{${1}X.XX$2}xms; s{\d\d\d\d-\d\d-\d\d}{YYYY-MM-DD}xms' "$OUT"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

# test modes:
# grep
# echo replacements
# inplace change
# constant definitions
# pull constants

echo TEST $CMD GREPMODE no options set
TEST=grep-no-options
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS=""
	$PROGRAM $DEBUG < "$SAMPLE" > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD GREPMODE all options turned off acts as a grep for CSS color declarations
TEST=grep-noecho-noreverse-nocolor-noremap-nocanon-nonames
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --noecho --noreverse --nocolor-only --noremap --nocanonical --nonames"
	$PROGRAM $ARGS < "$SAMPLE" > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD GREPMODE From file and --reverse only acts as a grep -v for CSS color declarations
TEST=grep-noecho-reverse-nocolor-noremap-nocanon-nonames
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --noecho --reverse --nocolor-only --noremap --nocanonical --nonames $SAMPLE"
	$PROGRAM $ARGS > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD GREPMODE --color-only greps and shows only the CSS color values
TEST=grep-noecho-noreverse-color-noremap-nocanon-nonames
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --noecho --noreverse --color-only --noremap --nocanonical --nonames"
	$PROGRAM $ARGS < "$SAMPLE" > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD GREPMODE --remap only without --names or --canonical just acts as grep and replaces colors with defined constants
TEST=grep-remap
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --noecho --noreverse --nocolor-only --remap --nocanonical --nonames"
	$PROGRAM $ARGS < "$SAMPLE" > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD CONST constants with errors
TEST=const-errors
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=255
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --show-const --const-type=less --const=bg=#345 --const=@fg=#000 --const=border=@fg \
	--const=@bg=duplicate --const=loop=@loop1 --const=@loop1=loop \
	--const=err0= --const=err=@£42 --const=err2=@~42 --canonical --rgb"
	$PROGRAM $ARGS < "$EMPTY" > "$OUT" 2>&1 || ERR=$?
	assertCommandFails $ERR $EXPECT "$PROGRAM $ARGS"
	stripLineReferences "$OUT"
	assertFileHeadersEqual $LINES "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD CONST lessc constants defined by hand canonical names
TEST=const-manually-canon-names
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=1
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --show-const --canonical --names \
		--const-type=less $MANUAL_CONST"
	#echo $PROGRAM $ARGS from /dev/null
	$PROGRAM $ARGS < "$EMPTY" > "$OUT" 2>&1 || ERR=$?
	assertCommandSuccess $ERR "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD CONST lessc constants defined by hand canonical rgb
TEST=const-manually-canon-rgb
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=1
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --show-const --canonical --rgb \
	--const-type=less  $MANUAL_CONST"
	$PROGRAM $ARGS < "$EMPTY" > "$OUT" 2>&1 || ERR=$?
	assertCommandSuccess $ERR "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD CONST constants defined in a file
TEST=const-file-canon-names
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=1
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --show-const --canonical --names \
	--const-type=less --const-file=$VARS"
	#echo $PROGRAM $ARGS from /dev/null
	$PROGRAM $ARGS < "$EMPTY" > "$OUT" 2>&1 || ERR=$?
	assertCommandSuccess $ERR "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

# TODO implement sass constants

echo TEST $CMD SASS constants defined by hand canonical names
TEST=const-sass-manually-canon-names
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=255
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --show-const --canonical --names \
	--const-type=sass --const=bg=#345 --const=fg=black --const=border=\$fg \
	--const=bg=duplicate"
	$PROGRAM $ARGS < "$EMPTY" > "$OUT" 2>&1 || ERR=$?
	assertCommandFails $ERR $EXPECT "$PROGRAM $ARGS"
#	assertCommandSuccess $ERR "$PROGRAM $ARGS"
#	assertFilesEqual "$OUT" "$BASE" "$TEST"
	stripLineReferences "$OUT"
	assertFileHeadersEqual $LINES "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD SASS constants defined in a file
TEST=const-sass-file-canon-names
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=255
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --show-const --canonical --names \
	--const-type=sass --const-file=$VARS"
	$PROGRAM $ARGS < "$EMPTY" > "$OUT" 2>&1 || ERR=$?
	assertCommandSuccess $ERR "$PROGRAM $ARGS"
	stripLineReferences "$OUT"
#	assertFilesEqual "$OUT" "$BASE" "$TEST"
	assertFileHeadersEqual 10 "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD ECHOMODE show original and changed value, --canonical only implies --remap
TEST=echo-canon
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --echo --noreverse --nocolor-only --noremap --canonical --nonames --nohash"
	$PROGRAM $ARGS < "$SAMPLE" > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD ECHOMODE --shorten only implies --remap
TEST=echo-shorten
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --echo --noreverse --nocolor-only --noremap --shorten --nonames --nocanonical --nohash"
	#echo $PROGRAM $ARGS $SAMPLE
	$PROGRAM $ARGS < "$SAMPLE" > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD ECHOMODE --hash --valid-only only implies --remap
TEST=echo-hash-valid-only
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --echo --noreverse --nocolor-only --noremap --noshorten --nonames --nocanonical --hash --valid-only"
	#echo $PROGRAM $ARGS $SAMPLE
	$PROGRAM $ARGS < "$SAMPLE" > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD ECHOMODE --hash --novalid-only shows color of rgba/hsla values
TEST=echo-hash
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --echo --noreverse --nocolor-only --noremap --noshorten --nonames --nocanonical --hash --novalid-only"
	#echo $PROGRAM $ARGS $SAMPLE
	$PROGRAM $ARGS < "$SAMPLE" > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD ECHOMODE --names only implies --remap, --canonical, --hash
TEST=echo-names
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --echo --noreverse --nocolor-only --noremap --nocanonical --names --novalid-only"
	$PROGRAM $ARGS < "$SAMPLE" > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD ECHOMODE --names and --valid-only
TEST=echo-names-valid
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --echo --noreverse --nocolor-only --noremap --nocanonical --names --valid-only"
	$PROGRAM $ARGS < "$SAMPLE" > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD ECHOMODE --rgb color mode
TEST=echo-rgb
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --echo --noreverse --nocolor-only --noremap --nocanonical --nonames --novalid-only --rgb"
	$PROGRAM $ARGS < "$SAMPLE" > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD CONST ECHOMODE remap colours with constants defined in a file
TEST=echo-const-file-remap
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=1
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --echo --remap \
	--const-type=less --const-file=$VARS"
	echo $PROGRAM $ARGS from $SAMPLE_REMAP
	$PROGRAM $ARGS < "$SAMPLE_REMAP" > "$OUT" 2>&1 || ERR=$?
	assertCommandSuccess $ERR "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi


# TODO rename to remap- prefix

echo TEST $CMD REMAPMODE --canonical only implies --remap
TEST=noecho-noreverse-nocolor-noremap-canon-nonames
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --noecho --noreverse --nocolor-only --noremap --canonical --nonames"
	$PROGRAM $ARGS < "$SAMPLE" > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD REMAPMODE --shorten only implies --remap
TEST=noecho-noreverse-nocolor-noremap-shorten-nonames
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --noecho --noreverse --nocolor-only --noremap --shorten --nonames"
	#echo $PROGRAM $ARGS $SAMPLE
	$PROGRAM $ARGS < "$SAMPLE" > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD REMAPMODE --names only implies --remap and --canonical
TEST=noecho-noreverse-nocolor-noremap-nocanon-names
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --noecho --noreverse --nocolor-only --noremap --nocanonical --names"
	$PROGRAM $ARGS < "$SAMPLE" > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD REMAPMODE --remap --canonical and --names against previous test base file
TEST=noecho-noreverse-nocolor-remap-canon-names
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/noecho-noreverse-nocolor-noremap-nocanon-names.base
	ARGS="$DEBUG --noecho --noreverse --nocolor-only --remap --canonical --names"
	$PROGRAM $ARGS < "$SAMPLE" > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD REMAPMODE --rgb only implies --remap and --canonical
TEST=noecho-noreverse-nocolor-noremap-nocanon-nonames-rgb
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --noecho --noreverse --nocolor-only --noremap --nocanonical --nonames --rgb"
	$PROGRAM $ARGS < "$SAMPLE" > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo "TEST $CMD REMAPMODE --valid-only --names will not convert rgba(0,0,0,0.3) to rgba(black,0.3)"
TEST=validonly-names
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --valid-only --names"
	$PROGRAM $ARGS < "$SAMPLE" > "$OUT" || assertCommandSuccess $? "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD INPLACEMODE --inplace=.bak --names test in place modification with backup file
TEST=inplace
if [ 0 == "$SKIP" ]; then
	ERR=0
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --inplace=.bak --names $OUT"

	#echo cp $SAMPLE $OUT\; $PROGRAM $ARGS
	cp "$SAMPLE" "$OUT"
	$PROGRAM $ARGS || assertCommandSuccess $? "$PROGRAM $ARGS"
	# check original was backed up
	assertFilesEqual "$SAMPLE" "$OUT.bak" "$TEST backup created"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD --foreground --background not allowed with --color-only
TEST=color-only-forground-background
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=1
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --color-only --foreground=yellow --background=black"
	$PROGRAM $ARGS > "$OUT" 2>&1 || ERR=$?
	assertCommandFails $ERR $EXPECT "$PROGRAM $ARGS"
	assertFileHeadersEqual $LINES "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

# TODO foreground/background test once implemented

echo TEST $CMD CONST REMAPMODE remap colours with constants defined in a file
TEST=const-file-remap
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=1
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --remap --inplace=.bak \
	--const-type=less --const-file=$VARS"
	cp "$SAMPLE_REMAP" "$OUT"
	$PROGRAM $ARGS "$OUT" 2>&1 || ERR=$?
	assertCommandSuccess $ERR "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD CONST REMAPMODE remap colours with constants defined in a file list options
TEST=const-file-remap-list
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=1
	OUT=out/$TEST.out
	BASE=base/$TEST.base
	ARGS="$DEBUG --remap --inplace=.bak \
	--const-type=less --const-file=$VARS --const-list"
	cp "$SAMPLE_REMAP" "$OUT"
	$PROGRAM $ARGS "$OUT" 2>&1 || ERR=$?
	assertCommandSuccess $ERR "$PROGRAM $ARGS"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD CONST REMAPMODE remap colours and pull new constants
TEST=const-file-pull
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=1
	OUT=out/$TEST.out
	OUT_NEW_CONST=out/$TEST.pulled.out
	BASE=base/$TEST.base
	BASE_NEW_CONST=base/$TEST.pulled.base
	ARGS="$DEBUG --remap --shorten --names --valid \
	--inplace=.bak --const-type=less --const-pull=$OUT_NEW_CONST"
	echo cp "$SAMPLE" "$OUT" \; $PROGRAM $ARGS "$OUT"
	cp "$SAMPLE" "$OUT"
	$PROGRAM $ARGS "$OUT" 2>&1 || ERR=$?
	assertCommandSuccess $ERR "$PROGRAM $ARGS"
	assertFilesEqual "$OUT_NEW_CONST" "$BASE_NEW_CONST" "$TEST"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

echo TEST $CMD CONST REMAPMODE remap colours and pull new constants no rename
TEST=const-file-pull-canonical
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=1
	OUT=out/$TEST.out
	OUT_NEW_CONST=out/$TEST.pulled.out
	BASE=base/$TEST.base
	BASE_NEW_CONST=base/$TEST.pulled.base
	ARGS="$DEBUG --valid --canonical \
	--inplace=.bak --const-type=less --const-pull=$OUT_NEW_CONST"
	echo cp "$SAMPLE" "$OUT" \; $PROGRAM $ARGS "$OUT"
	cp "$SAMPLE" "$OUT"
	$PROGRAM $ARGS "$OUT" 2>&1 || ERR=$?
	assertCommandSuccess $ERR "$PROGRAM $ARGS"
	assertFilesEqual "$OUT_NEW_CONST" "$BASE_NEW_CONST" "$TEST"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

exit 1;

echo TEST $CMD parameters passed to rules
TEST=const-rules-have-parameters
if [ 0 == "$SKIP" ]; then
	ERR=0
	EXPECT=1
	OUT=out/$TEST.out
	OUT_NEW_CONST=out/$TEST.pulled.out
	BASE=base/$TEST.base
	BASE_NEW_CONST=base/$TEST.pulled.base
	ARGS="$DEBUG --valid --canonical \
	--inplace=.bak --const-type=less --const-pull=$OUT_NEW_CONST\
	--const-file=in/variables.less"
	echo cp "$SAMPLE_RULE_PARAMS" "$OUT" \; $PROGRAM $ARGS "$OUT"
	cp "$SAMPLE_RULE_PARAMS" "$OUT"
	$PROGRAM $ARGS "$OUT" 2>&1 || ERR=$?
	assertCommandSuccess $ERR "$PROGRAM $ARGS"
	assertFilesEqual "$OUT_NEW_CONST" "$BASE_NEW_CONST" "$TEST"
	assertFilesEqual "$OUT" "$BASE" "$TEST"
else
	echo SKIP $TEST "$SKIP"
fi

cleanUpAfterTests
