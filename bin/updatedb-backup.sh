#!/bin/bash

CFG=$HOME/.BACKUP
[ -e $CFG ] && source $CFG

DBDIR=/var/lib/mlocate
EXTERNAL=/media/me

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] [--notify] [--list] [backup-drive]

This will index an external backup drive for the locate command and keep the database both on the drive and locally for searching when it is detached.

backup-drive  The path to a mounted backup drive to index.
--list        Will list all the local locate databases availble.
--notify      After indexing is complete, an alarm will be played and a system notification will be sent.
--man         Shows help for this tool.
--help        Shows help for this tool.
-?            Shows help for this tool.

If the backup-drive path does not exist, all local locate databases will be listed for you as well as all mounted external backup drives.

The local copy of the locate database will be saved in $DBDIR as well as a copy on the backup drive.

See also updatedb.sh locatebk.sh locatebkall.sh lokate.sh locate updatedb

Example:

	$cmd --notify /media/me/BIG-DRIVE
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

function list {
	local code
	code=$1
	echo Currently mounted external backup drives are:
	ls -1 $EXTERNAL/
	echo Currently available local mlocate backup databases are:
	ls -1 $DBDIR/mlocate-*
	echo You can use the locatebk.sh or locatebkall.sh command to search these for files if you like.
	exit $code
}

if [ "$1" == "--list" ]; then
	list 0
fi

if [ "$1" == "--notify" ]; then
	NOTIFY=1
	shift
fi

if [ -z "$1" ] && [ -z "$BK_DEV" ] ; then
	echo "you must provide a backup destination on the command line or as BK_DEV in $CFG"
	echo ""
	usage 1
fi

BACKUP=${1:-$BK_DEV}
NAME=`basename $BACKUP`
LOCATE=mlocate-$NAME.db
DB=$DBDIR/$LOCATE
DBBK=$BACKUP/mlocate.db

if [ "$1" == "--notify" ]; then
	NOTIFY=1
	shift
fi

if [ ! -d "$BACKUP" ]; then
	echo Backup drive $BACKUP is not mounted, cannot update the mlocate database.
	list 10
fi

if [ ! -z $NOTIFY ]; then
	echo Updating mlocate database for backup disk: $BACKUP at $DB
	START=`date`
	echo $START
fi

echo Need root access to update mlocate database at $DB
ls -al $DB
sudo updatedb --require-visibility=no --output $DB --database-root $BACKUP
ls -al $DB
sudo cp $DB $DBBK
sudo chmod +r $DBBK

if [ ! -z $NOTIFY ]; then
	CR=`perl -e "print qq{\n}"`
	END=`date`
	echo $END
	echo Try a lookup on the index...
	locatebk.sh $BACKUP e | head -5
	MESSAGE="Backup drive $BACKUP has been indexed for locatebk.sh or locatebkall.sh command."
	which cowsay > /dev/null && cowsay "$MESSAGE$CR  $START$CR  $END"
	mynotify.sh "updatedb-backup.sh" "$MESSAGE"
	alarm.sh
fi
