#!/bin/bash
# run each jest test suite individually to find where unhandled promise rejections and other warnings come from.
TESTLOG=_tests.log
LOG=_test-all.log
[ -e $LOG ] && rm $LOG
START=`date`
date >> $LOG
for file in `find src -name *.test.js`
do
	perl -e '$div = "=" x 76; print qq{$div\n}' >> $LOG
	echo $file >> $LOG
	test-one.sh "$file"
	cat $TESTLOG >> $LOG
done
perl -e '$div = "=" x 76; print qq{$div\n}' >> $LOG
echo Time to run all tests individually >> $LOG
echo Begin: $START >> $LOG
echo End: `date` >> $LOG
