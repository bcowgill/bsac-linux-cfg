# updatedb-backup.sh; cowsay "Backup drive has been indexed for locatebk.sh command"; alarm.sh

# see also updatedb.sh locatebk.sh lokate.sh locate updatedb

if [ "$1" == "--notify" ]; then
	NOTIFY=1
	shift
fi

BACKUP=${1:-/media/me/ADATA-4TB}
NAME=`basename $BACKUP`
LOCATE=mlocate-$NAME.db
DBDIR=/var/lib/mlocate
DB=$DBDIR/$LOCATE
DBBK=$BACKUP/mlocate.db

if [ "$1" == "--notify" ]; then
	NOTIFY=1
	shift
fi

if [ ! -d "$BACKUP" ]; then
	echo Backup drive $BACKUP is not mounted, cannot update the mlocate database.
	echo Currently available local mlocate backup databases are:
	ls -1 $DBDIR/mlocate-*
	echo You can use the locatebk.sh command to search these for files if you like.
	exit 10
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
	locatebk.sh mlocate
	MESSAGE="Backup drive $BACKUP has been indexed for locatebk.sh command"
	cowsay "$MESSAGE$CR  $START$CR  $END"
	mynotify.sh "updatedb-backup.sh" "$MESSAGE"
	alarm.sh
fi
