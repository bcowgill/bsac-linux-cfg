#!/bin/bash
# see also scan-tree.sh, locatebkall.sh, updatedb-backup.sh, updatedb.sh, locate, lokate.sh, updatedb, find
#
#  Find a specific Billy Idol song from a local backup database
#
# Example:
#  $cmd VELDA-2TB -i billy | grep -i idol | grep -i flesh
#

CFG=$HOME/.BACKUP
[ -e $CFG ] && source $CFG

if [ -z "$1" ] && [ -z "$BK_DEV" ] ; then
	echo "you must provide a backup destination on the command line or as BK_DEV in $CFG"
	exit 1
fi

if [ -z "$2" ]; then
	BACKUP=$BK_DEV
else
	BACKUP=${1:-$BK_DEV}
	if basename $BACKUP > /dev/null 2> /dev/null; then
		shift
	fi
fi

NAME=`basename $BACKUP 2>/dev/null 2>/dev/null || basename $BK_DEV`
echo NAME=$NAME
LOCATE=mlocate-$NAME.db
DBDIR=/var/lib/mlocate
DB=$DBDIR/$LOCATE
DBBK=$BACKUP/mlocate.db

function list_backups {
	echo Currently available local mlocate backup databases are:
	pushd $DBDIR > /dev/null && ls mlocate-* | perl -pne 's{mlocate-(.+)\.db}{$1}xmsg'; popd > /dev/null
}

if [ ! -e "$DB" ]; then
	if [ ! -e "$DBBK" ]; then
		echo "Cannot find the backup drive's mlocate database in $DB or $DBBK."
		list_backups
		exit 10
	else
		DB="$DBBK"
	fi
fi

if [ -z "$1" ]; then
	echo locate: no pattern to search for specified
	list_backups
	exit 20
fi
locate --database $DB $*
