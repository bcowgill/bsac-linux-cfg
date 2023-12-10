#!/bin/bash

LOCKER=./lock.sh
PW=PASSWDS.TXT
if [ -e $LOCKER ] && [ -e $PW ] ; then
	LOCK=`mktemp`

	cp $LOCKER $LOCK
	chmod go-rwx $LOCK
	chmod u+x $LOCK
	echo $LOCK
	ls -al $LOCK
	echo Running the lock command for the USB drive `pwd`
	$LOCK
	ERR=$?
	rm $LOCK
	if [ $ERR -gt 0 ]; then
		exit $ERR
	fi
	echo Do you want to remove sensitive files and wipe the free space also [y/N] ?
	read WHAT
	if [ "$WHAT" == "y" ]; then
		rm $PW && wipe.sh
	fi
else
	echo "You don't appear to be in a mounted USB drive directory with a lock script on it."
fi
