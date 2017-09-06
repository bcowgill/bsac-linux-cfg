#!/bin/bash
# test fortune files

LIB=/usr/share/games/fortunes

function test_fortune_output
{
	local file FILE count SUCCESS FAILS
	FAILS=0
	SUCCESS=0
	file="$1"
	count=100
	while [ $count != -1 ]; do
		echo try $count $FAILS $SUCCESS
		if [ 0 == `fortune "$file" | wc -l` ]; then
			echo "NOT OK fortune shows no output"
			FAILS=$[$FAILS + 1]
		else
			echo "OK fortune shows some output"
			SUCCESS=$[$SUCCESS + 1]
		fi
		count=$[$count - 1]
	done
	FILE=`fortune -f "$file" 2>&1`
	if [ 0 == $SUCCESS ]; then
		echo "NOT OK fortune $FILE shows no output ever"
	else
		echo OK fortune $file shows something at least some of the time.
		if [ 0 != $FAILS ]; then
			echo "NOT COMPLETELY OK fortune $FILE shows no output sometimes"
		fi
	fi
}

function test_fortune
{
	local file FILE
	file="$1"
	if fortune "$file" > /dev/null; then
		echo OK fortune $file returns zero
		test_fortune_output "$file"
	else
		FILE=`fortune -f "$file" 2>&1`
		echo "NOT OK fortune $FILE returns non-zero"
	fi
}

test_fortune "$1"

