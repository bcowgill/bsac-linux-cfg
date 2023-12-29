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

SEEN=$0.lst
SAVED=$0.saved.lst
ERRS=$0.err.lst
touch $SEEN

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] [--save]

This will show you a random manual page of the day so you can get to know the system commands available.

--save  Will append the previous manual page of the day to the $SAVED file.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

This will select a random system executable command and show the manual page for it.  The list of viewed pages is recorded in file: $SEEN

If the manual page for a command returns an error it will be added to the error file: $ERRS

See also choose.pl, random-order.sh, random-text.sh
"
	exit $code
}
if [ "$1" == "--help" ]; then
	usage 0
fi
if [ "$1" == "--man" ]; then
	usage 0
fi
if [ "$1" == "-?" ]; then
	usage 0
fi
if [ "$1" == "--save" ]; then
	tail -1 $SEEN
	tail -1 $SEEN >> $SAVED
	exit 0
fi

TMP=`mktemp`

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
