# see also updatedb-backup.sh updatedb.sh locate lokate.sh updatedb

BACKUP=${1:-/media/me/ADATA-4TB}
NAME=`basename $BACKUP`
LOCATE=mlocate-$NAME.db
DB=/var/lib/mlocate/$LOCATE
DBBK=$BACKUP/mlocate.db

if [ ! -z "$1" ]; then
	shift
fi

if [ ! -e "$DB" ]; then
	if [ ! -e "$DBBK" ]; then
		echo "Cannot find the backup drive's mlocate database in $DB or $DBBK."
		exit 10
	else
		DB="$DBBK"
	fi
fi

locate --database $DB $*
