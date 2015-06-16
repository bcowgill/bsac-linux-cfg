#!/bin/bash
# a text mode screen saver using the linuxlogo program

SLEEP=20

function rand
{
	local min max
	min=$1
	max=$2
	perl -e '
	my ($min, $max) = @ARGV;
	$range = $max - $min;
	print int($min + 0.5 + rand() * $range);' $min $max
}

function choose
{
	local run
	run="$1"
	if [ -z "$CHOICE" ]; then
		perl -e 'exit 1 if rand() < 0.1; exit 0;' || CHOICE="$run"
	fi
}

function output
{
	local command down indent
	command="$1"
	down=`rand 3 15`
	indent=`rand 3 30`
	perl -e 'print qq{\n} x $ARGV[0]' $down
	clear
	$command -o $indent
	#echo $down $indent
	#echo $command -o $indent
	#read wait
}

function logo
{
	local which
	CHOICE=""
	while [ -z "$CHOICE" ];
	do
		for which in 2 3 6 7 8 9 10 12 13 14 15 ; do
			choose $which
		done
	done
	LOGO=$CHOICE
	CHOICE=""
	while [ -z "$CHOICE" ];
	do
		for which in -- -a -k -l ; do
			choose $which
		done
	done
	[ "$CHOICE"=="--" ] && CHOICE=""
	output "linuxlogo $OPTS $CHOICE -L $LOGO"
}

# ignore rc file, show uptime and load average
OPTS="-i -u -y"

if which linuxlogo > /dev/null ; then
	while true; do
		logo
		sleep $SLEEP
	done
fi
