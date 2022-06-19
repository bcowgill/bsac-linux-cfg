# see also updatedb-backup.sh updatedb.sh locate lokate.sh updatedb

BK_DEV=/media/me/ADATA-4TB

if [ -z "$2" ]; then
	BACKUP=$BK_DEV
else
	BACKUP=${1:-$BK_DEV}
	shift
fi

NAME=`basename $BACKUP`
LOCATE=mlocate-$NAME.db
DB=/var/lib/mlocate/$LOCATE
DBBK=$BACKUP/mlocate.db

if [ ! -e "$DB" ]; then
	if [ ! -e "$DBBK" ]; then
		echo "Cannot find the backup drive's mlocate database in $DB or $DBBK."
		exit 10
	else
		DB="$DBBK"
	fi
fi

locate --database $DB $*
