# updatedb-backup.sh; cowsay "Backup drive has been indexed for locatebk.sh command"; alarm.sh

# see also updatedb.sh locatebk.sh lokate.sh locate updatedb
BACKUP=/media/me/ADATA-4TB
LOCATE=mlocate-ADATA-4TB.db
DB=/var/lib/mlocate/$LOCATE

NOTIFY=$1

if [ ! -z $NOTIFY ]; then
	echo Updating locate database for backup disk: $BACKUP at $DB
	START=`date`
	echo $START
fi

sudo updatedb --output $DB --database-root $BACKUP
sudo cp $DB $BACKUP
sudo chmod +r $BACKUP/$LOCATE

if [ ! -z $NOTIFY ]; then
	END=`date`
	echo $END
	locatebk.sh mlocate
	MESSAGE="Backup drive $BACKUP has been indexed for locatebk.sh command"
	cowsay "$MESSAGE $START to $END"
	mynotify.sh "updatedb-backup.sh" "$MESSAGE"
	alarm.sh
fi
