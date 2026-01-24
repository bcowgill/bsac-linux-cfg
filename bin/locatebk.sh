#!/bin/bash
cmd=$(basename $0)

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
if [ "$1" != "--list" ]; then
echo NAME=$NAME
fi
LOCATE=mlocate-$NAME.db
DBDIR=/var/lib/mlocate
DB=$DBDIR/$LOCATE
DBBK=$BACKUP/mlocate.db

function list_backups {
	if [ "$1" == "--help" ]; then
		echo Currently available local mlocate backup databases are:
	fi
	pushd $DBDIR > /dev/null && ls mlocate-* | perl -pne 's{mlocate-(.+)\.db}{$1}xmsg'; popd > /dev/null
}

if [ ! -e "$DB" ]; then
	if [ ! -e "$DBBK" ]; then
		echo "Cannot find the backup drive's mlocate database in $DB or $DBBK."
		list_backups --help
		exit 10
	else
		DB="$DBBK"
	fi
fi

if [ "$1" == "--list" ]; then
	list_backups
	exit $?
fi
if [ -z "$1" ]; then
	echo locate: no pattern to search for was specified
	list_backups --help
	exit 20
fi

HELP=

if [ "$1" == "-h" ]; then
	HELP=1
fi
if [ "$1" == "--help" ]; then
	HELP=1
fi
if [ "$1" == "--man" ]; then
	HELP=1
fi
if [ "$1" == "-?" ]; then
	HELP=1
fi

if [ ! -z $HELP ]; then
	locate -h | EXE="$cmd" BK_DEV="$BK_DEV" DBDIR="$DBDIR" perl -pne 's{\blocate\b}{$ENV{EXE} [DB VOL NAME] }xms; s{in\ a\ mlocate\ database}{"in an external backup disk mlocate database.
The default database to use is configured as BK_DEV [$ENV{BK_DEV}] in the $CFG configuration file.
You can override the default by passing the volume name as the first parameter.
The mlocate database for each external backup drive is stored in $ENV{DBDIR} and named as the volume label of the backup disk.
If no parameters or (--list) are given, a list of all the mlocate databases will be shown"}xmse'
	echo "

Examples:

  Find a specific Billy Idol song from a specific local backup database.

  $cmd VELDA-2TB -i billy | grep -i idol | grep -i flesh

  List the top level files and direectories for the 'Expansion' backup drive.

  BKD=Expansion
  $cmd \$BKD --regex '^/.+?/'\$BKD'/[^/]+$' | BKD=\"\$BKD\" perl -pne 's{\A/.+?/\$ENV{BKD}/}{}xms'

  List the top level files and direectories for the 'Expansion' backup drive and append ::Expansion to each line for identification.

  $cmd \$BKD --regex '^/.+?/'\$BKD'/[^/]+$' | BKD=\"\$BKD\" perl -pne 'next if s{\ANAME=.+\z}{}xms; s{\A/.+?/\$ENV{BKD}/}{}xms; s{\s*\z}{ ::\$ENV{BKD}\n}xms'

  List the two top level files and direectories for the 'Expansion' backup drive and append ::Expansion to each line for identification.

  $cmd \$BKD --regex '^/.+?/'\$BKD'/[^/]+(/[^/]+)?$' | BKD=\"\$BKD\" perl -pne 'next if s{\ANAME=.+\z}{}xms; s{\A/.+?/\$ENV{BKD}/}{}xms; s{\s*\z}{ ::\$ENV{BKD}\n}xms'
see also scan-tree.sh, locatebkall.sh, updatedb-backup.sh, updatedb.sh, locate, lokate.sh, updatedb, find
"
	exit 0
else
	locate --database $DB $*
fi
