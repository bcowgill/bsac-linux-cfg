#!/bin/bash
# Show a randomly selected manual page based on the executable files found in the configured path.
# Maintains a list of already viewed manual pages to prevent duplicates.

function debug
{
	#echo $*
	/bin/true
}

PTH="
	/usr/local/sbin
	/usr/local/bin
	/usr/sbin
	/usr/bin
	/sbin
	/bin
	/usr/games
	/usr/local/games
"

TMP=`mktemp`
SEEN=$0.lst
ERRS=$0.err.lst
touch $SEEN

function count
{
	VIEWED=`wc -l < $SEEN`
	FOUND=`wc -l < $TMP`
	debug TOTAL=$TOTAL FOUND=$FOUND VIEWED=$VIEWED
}

FILTER=$(perl -ne '
	chomp;
	push(@X,$_);
	END
	{
		print(q{^(} . join("|",@X) . q{)$});
	}
' $SEEN
)
debug FILTER="$FILTER"

debug TMP=$TMP

find $PTH \
	-type f \
	-executable \
> $TMP
count
TOTAL=$FOUND
grep -vE "$FILTER" $TMP > $TMP.XXX
mv $TMP.XXX $TMP

function quit
{
	local code
	code=${1:-0}
	rm $TMP
	exit $code
}

function choose
{
	CMD=`choose.pl < $TMP`
	if [ -z "$CMD" ]; then
		echo No executable commands found in configured PATH: $PTH
		echo Your current path is: $PATH
		echo You may want to adjust the path configured in $0
		quit 1
	fi
	debug CMD=$CMD
	TOPIC=`basename $CMD`
}

SHOWN=
while [ ! $SHOWN ]; do
	count
	if [ $VIEWED -ge $TOTAL ]; then
		echo "You have seen the manual page for all $TOTAL commands found.  You should delete the file '$SEEN' to view them again."
		quit 10
	fi
	choose
	if grep $CMD $SEEN > /dev/null; then
		/bin/true
	else
		man $TOPIC
		ERR=$?
		echo $CMD >> $SEEN
		if [ $ERR == 0 ]; then
			count
			echo "Showed manual page for $TOPIC ($VIEWED/$TOTAL)"
			SHOWN=1
		else
			echo $CMD >> $ERRS
		fi
	fi
done
