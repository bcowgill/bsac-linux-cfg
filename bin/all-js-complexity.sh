#!/bin/bash
# generate javascript complexity information for all repositories
# as defined by PJ and REPOS environment variables

MAX=32

if [ -z "$PJ" ]; then
	echo NOT OK you must define the PJ environment variable to indicate where your git projects are. i.e. $HOME/workspace
	exit 1
else
	if [ -z "$REPOS" ]; then
		echo NOT OK you must define the REPOS environment variable to indicate which git repository directories to process
		exit 2
	fi
	pushd $PJ
fi

LOG=complexity.log
OUT=complexity.txt
JSON=complexity.json

rm $LOG combined-$JSON
touch $LOG
echo "[" > combined-$JSON

series=0
for dir in $REPOS
do
	echo " "
	echo $dir ======================================================
	pushd $dir > /dev/null
		jshint-add-complexity.sh .jshintrc 1
		jshint-set-complexity-js.sh 1 `find app/scripts -name '*.js' 2> /dev/null` `find lib/scripts -name '*.js' 2> /dev/null`
		grunt --no-color jshint | tee $LOG >> ../$LOG
		jshint-analyse-complexity.sh $dir $series $MAX $LOG > $OUT 2> $JSON
		cat $JSON >> ../combined-$JSON
		echo "," >> ../combined-$JSON
		echo $OUT $JSON created
		head -4 $OUT
		series=$(( $series + 1 ))
	popd > /dev/null
done

echo "Overall Complexity" > $OUT
echo "complexity 1 ignored in all counts and averages" >> $OUT
jshint-analyse-complexity.sh overall $series $MAX $LOG >> $OUT 2> $JSON
for dir in $REPOS
do
	pushd $dir > /dev/null
	echo " " >> ../$OUT
	echo $dir Complexity >> ../$OUT
	cat $OUT >> ../$OUT
	popd > /dev/null
	clean.sh
done
cat $JSON >> combined-$JSON
echo "]" >> combined-$JSON

echo " "
echo $OUT $JSON combined-$JSON created with full complexity results
head -9 $OUT