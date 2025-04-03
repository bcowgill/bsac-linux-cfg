#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

FILE=FILL-UP-DISK-DELETE.DAT
CWD=`pwd`
WHERE=${1:-$CWD}
MAX_PASS=${PASSES:-5}
BLOCKS=${BLOCKS:-25}
PERCENT=${PERCENT:-1}

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] path

Wipe free space on a specific path or current directory by writing random data to files named ...$FILE until it fills up. Then deleting them and going again for $MAX_PASS passes.

path    Specify the device path to fill up. Defaults to current directory.
PASSES  Environment variable to change the number of passes to do.
BLOCKS  Set the number of block files to use to fill up space. default $BLOCKS.
PERCENT Set to display % complete on each pass with a banner program. default $PERCENT
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

Creates files named [PASS]-[NUM]$FILE of fixed block size and writes random data to them until all disk space is used up.

Will use banner, figlet or toilet programs to display % complete on each pass number.

Once complete a file named WIPED-N-PASSES.txt will be placed on the drive to indicate how many wipe passes succeeded.

You can stop wiping after the current pass by touching the file STOP-PASS in the path specified.

On the last pass it populates from forever.pl (if available) instead of the system random device.

See also wipe-phrase.sh lock.sh lockusb.sh
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

LOG=`mktemp`
WIPELOG=`mktemp --suffix=.log --tmpdir wipe-timing.XXXXXXXXXX`
FREE=`df -k "$WHERE" | tail -1 | awk {'print $4'}`
USED=`df -k "$WHERE" | tail -1 | awk {'print $5'}`

if [ $FREE -lt 1000000  ]; then
	BLOCKS=4
fi

SIZE=$(($FREE/$BLOCKS))
CHUNKS=$SIZE
BYTES=$(($SIZE*1024))
PASSLIST=`perl -e 'print join(" ", (1 .. $ARGV[0]))' $MAX_PASS`
FILEMASK="$WHERE/*$FILE"

#echo BLOCKS=$BLOCKS
#echo USED=$USED
#echo FREE=$FREE
#echo FREEBYTES=$(($FREE*1024))
#echo SIZE=$SIZE
#echo BYTES=$BYTES
#echo CHUNKS=$CHUNKS
#echo TOTAL=$(($BYTES*$BLOCKS))
#echo FILEMASK="$WHERE/*$FILE"

function log {
	echo "$*"
	echo "$*" >> "$WIPELOG"
}

function say {
	local MSG
	MSG="$*"
	if [ "$PERCENT" == 1 ]; then
		if which toilet > /dev/null; then
			echo " "
			toilet -f pagga "$MSG"
			echo " "
		elif which figlet > /dev/null; then
			figlet -f smslant "$MSG"
			echo " "
		elif which banner > /dev/null; then
			echo " "
			banner "$MSG"
		fi
	fi
}

function datestamp {
	date '+%Y-%m-%d %H:%M:%S%z' | perl -pne 's{(\d\d \s*) \z}{:$1}xmsg'
}

function dump {
	local random
	random=1
	if [ $PASS == $MAX_PASS ]; then
		if which forever.pl > /dev/null; then
			forever.pl | dd bs=1024c count=$CHUNKS
			random=0
		fi
	fi
	if [ $random == 1 ]; then
		dd if=/dev/urandom bs=1024c count=$CHUNKS
	fi
}

echo "
$FREE K free on $WHERE = $USED Full
Will write $BLOCKS files of $SIZE K each pass to fill the disk and repeat for $MAX_PASS passses.
NOTE: You can stop after the current pass with command:
touch $WHERE/STOP-PASS

Press Enter to WIPE FREE SPACE on $WHERE or Ctrl-C to stop
"
read go
log "starting wipe  @ `datestamp`"

NUM=0
LAST=
for PASS in $PASSLIST;
do
	ERR=0
	if [ ! -e "$WHERE/STOP-PASS" ]; then
		echo "----------"
		log "Wiping pass $PASS  @ `datestamp`"
		while [ $ERR == "0" ]; do
			TO="$WHERE/$PASS-$NUM-$FILE"
			if which pv > /dev/null ; then
				dump 2> "$LOG" | pv -N "#$PASS-$NUM" -i 0.1 -s "$BYTES" > "$TO"
				ERR=$?
			else
				dump > "$TO" 2> "$LOG"
				ERR=$?
			fi
			# match this:   134217724 bytes (134 MB) copied, 11.0026 s, 12.2 MB/s
			# but not this: dd: warning: partial read (33554431 bytes); suggest iflag=fullblock
			RATE=`grep -E 'bytes.+copied' $LOG`
			USED=`df -k "$WHERE" | tail -1 | awk {'print $5'}`
			echo "   #$PASS: Syncing @ `datestamp`"
			sync
			say "$USED Pass#$PASS"
			log "   $USED Full, $RATE"
			NUM=$(($NUM+1))
		done;
		echo "   #$PASS: Removing files of random data @ `datestamp`"
		rm $FILEMASK
		WIPED="$WHERE/WIPED-$PASS-PASSES.txt"
		touch "$WIPED"
		if [ ! -z "$LAST" ]; then
			rm "$LAST"
		fi
		LAST="$WIPED"
	fi
done
if [ -e "$WHERE/STOP-PASS" ]; then
	echo " "
	echo "Detected "$WHERE/STOP-PASS" to stop after current pass."
	rm "$WHERE/STOP-PASS"
fi

echo "Wrote $NUM blocks ($SIZE K) of random data."
log "ending wipe    @ `datestamp`"
echo "Timing information logged to: $WIPELOG"
rm "$LOG"
alarm.sh "" SkypeLogin.wav
