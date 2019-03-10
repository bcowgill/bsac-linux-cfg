#!/bin/bash
# scan the code and output for issues
# example used after a build to look for problems that have been seen before

DIST=dist-release
SCAN=scan.log
THIS=this-$SCAN
APP=bos/content/scripts/app.mount.min.js
if [ ! -f "$DIST/$APP" ]; then
	DIST=dist
	APP=bos/scripts/app.mount.js
fi

[ -f $SCAN ] && rm $SCAN

function report {
	COUNT=`wc -l < $THIS`

	echo " " >> $SCAN
	echo "===================================================" >> $SCAN
	echo $COUNT $DESC | tee -a $SCAN
	cat $THIS >> $SCAN
}

function reportN {
	local num
	num=$1
	COUNT=`wc -l < $THIS`

	echo " " >> $SCAN
	echo "===================================================" >> $SCAN
	if [ $num == $COUNT ]; then
		echo "OK $DESC" | tee -a $SCAN
	else
		echo $COUNT $DESC -- should be only $num | tee -a $SCAN
		cat $THIS >> $SCAN
	fi
}

DESC="MUST""DO Markers in the code"
git grep "MUS""TDO" > $THIS
report

DESC="TO""DO Markers in the code"
git grep "TO""DO" | grep -v -- -lib | grep -vE '/acceptance/|(demo|templates)/' > $THIS
report

DESC="Skipped Test Suites"
git grep -E describe\\.skip | grep -vE '/acceptance/|demo/|jest-setup-test|check-js-test-plans' > $THIS
report

DESC="Skipped Test Cases"
git grep -E it\\.skip | grep -vE '/acceptance/|demo/|jest-setup-test|check-js-test-plans' > $THIS
report

if [ -e $DIST ]; then
	NUM=6
	DESC="Math.random present in the $DIST built output"
	perl -pne 's{([,;{}])}{$1\n}xmsg' $DIST/$APP | grep Math.random > $THIS
	reportN $NUM

	DESC="/demo/ present in the $DIST built output"
	perl -pne 's{([,;{}])}{$1\n}xmsg' $DIST/$APP | grep /demo/ > $THIS
	report
fi

rm $THIS
cat $SCAN
