#!/bin/bash
# easy backup system just give source and destination. will do a full backup
# and then partial backups of what changed since last backup

#set -x

DEBUG=0

MODE=${1:-partial}

SOURCE="$2"
BK_DIR="$3"
if [ "$MODE" == "restore" ]; then
	FIND="$2"
	SOURCE="$3"
	BK_DIR="$4"
fi
if [ "$MODE" == "full" ]; then
	DO_FULL=1
fi

CFG=$HOME/.BACKUP

function usage {
	local message
	message="$1"
	echo $message
	echo " "
	echo usage:
	echo "$0 [restore|full|partial] [restore-pattern] [source-dir] [backup-dir]"
	echo " "
	echo Easy backup system provide a source-dir to backup and a backup-dir to store backups in.  Alternatively create a $CFG file which exports BK_DIR and SOURCE environment variables.
	echo " "
	echo If full option is provided a full backup is forced.
	echo " "
	echo If restoring you can specify a wildcard to get an entire directory.  It will restore to ./restore directory.  Specify the full relative path of the file to restore, not an absolute path.
	exit 1
}

function lock {
	LOCK_ERROR=1
	mkdir $BK_DIR/locked || die 1 "unable to lock in $BK_DIR"
	LOCK_ERROR=
	# on error during script, unlock
	trap 'error ${LINENO}' ERR
}

function unlock {
	rmdir $BK_DIR/locked > /dev/null
}

function die {
	local code message
	code=$1
	message="$2"
	log_error "$message"
	[ -z $LOCK_ERROR ] && unlock
	exit $code
}

# An error handler to trap premature terminations.
# source: http://stackoverflow.com/questions/64786/error-handling-in-bash
function error()
{
   local parent_lineno="$1"
   local message="$2"
   local code="${3:-1}"
   echo "$0: terminated by error while in `pwd`"
   if [[ -n "$message" ]] ; then
      echo "on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
   else
      echo "on or near line ${parent_lineno}; exiting with status ${code}"
   fi
	unlock
   exit "${code}"
}

function config {
	if [ -z "$BK_DIR" ]; then
		[ -e "$CFG" ] && source $CFG

		[ -z "$BK_DIR" ] && usage "you must provide a source and destination on command line or in $CFG"
		[ -z "$SOURCE" ] && usage "you must provide a source and destination on command line or in $CFG"
	fi

	[ -d $BK_DIR ] || mkdir -p "$BK_DIR"
	[ -d $SOURCE ] || usage "$SOURCE: SOURCE directory does not exist."
	[ -d $BK_DIR ] || usage "$BK_DIR: BK_DIR could not be created."

	if [ $DEBUG == 1 ]; then
		echo SOURCE=$SOURCE
		echo BK_DIR=$BK_DIR
	fi

	NUM_PARTIALS=${NUM_PARTIALS:-5}
	FULL=$BK_DIR/ezbackup.tgz
	FULL_SAVE=$BK_DIR/saved.full.tgz
	LAST_PARTIAL=$BK_DIR/ezbackup.$NUM_PARTIALS.tgz
	ALL_PARTIALS=$BK_DIR/ezbackup.*.tgz
	ALL_PARTIAL_LOGS=$BK_DIR/*.*.log
	ALL_PARTIAL_TIMESTAMPS=$BK_DIR/partial.*.timestamp

	lock
	if [ -z "$DO_FULL" ]; then
		[ -e "$LAST_PARTIAL" ] && DO_FULL=1
		[ ! -e "$FULL" ] && DO_FULL=1
	fi

	if [ $DEBUG == 1 ]; then
		echo DO_FULL=$DO_FULL
		echo FULL=$FULL
		echo FULL_SAVE=$FULL_SAVE
		echo LAST_PARTIAL=$LAST_PARTIAL
		echo ALL_PARTIALS=$ALL_PARTIALS
		echo ALL_PARTIAL_LOGS=$ALL_PARTIAL_LOGS
		echo ALL_PARTIAL_TIMESTAMPS=$ALL_PARTIAL_TIMESTAMPS
	fi
}

function backup {
	if [ -z "$DO_FULL" ]; then
		partial_backup
	else
		full_backup
	fi
}

function full_backup {
	TIMESTAMP="$BK_DIR/full-backup.timestamp"
   BACKUP="$FULL"
	define_logs

	[ -e "$FULL" ] && show_times && check_space
exit 2
	[ -e "$FULL" ] && mv "$FULL" "$FULL_SAVE"

	touch "$TIMESTAMP" && tar cvzf "$BACKUP" "$SOURCE/" > "$LOG" 2> "$ERRLOG"
	filter_logs

	rm $ALL_PARTIALS $ALL_PARTIAL_LOGS $ALL_PARTIAL_TIMESTAMPS 2> /dev/null
	if [ -e "$FULL_SAVE" ]; then
	    rm "$FULL_SAVE"
	fi
}

function partial_backup {
	NUM=1
	NEWER="$BK_DIR/full-backup.timestamp"
	while [ -e "$BK_DIR/ezbackup.$NUM.tgz" ];
	do
		NEWER="$BK_DIR/partial.$NUM.timestamp"
		NUM=$((NUM+1))
	done
	PARTIAL="$BK_DIR/ezbackup.$NUM.tgz"
	BACKUP="$PARTIAL"
	TIMESTAMP="$BK_DIR/partial.$NUM.timestamp"

	define_logs .$NUM
	touch "$TIMESTAMP" && tar cvzf "$BACKUP" --newer "$NEWER" "$SOURCE/" > "$LOG" 2> "$ERRLOG"
	filter_logs
}

function define_logs {
	local num
	num=$1

	LOG="$BK_DIR/backup$num.log"
	ERRLOG="$BK_DIR/stderr$num.log"
	FILELOG="$BK_DIR/files$num.log"
	DIRLOG="$BK_DIR/directories$num.log"
	FILENAMELOG="$BK_DIR/filenames$num.log"
	IGNORELOG="$BK_DIR/ignored-errors$num.log"
	ERRORSLOG="$BK_DIR/errors$num.log"
	touch $ERRORSLOG

	if [ $DEBUG == 1 ]; then
		echo NUM=$NUM
		echo TIMESTAMP=$TIMESTAMP
		echo NEWER=$NEWER
		echo BACKUP=$BACKUP
		echo LOG=$LOG
		echo ERRLOG=$ERRLOG
		echo FILELOG=$FILELOG
		echo DIRLOG=$DIRLOG
		echo FILENAMELOG=$FILENAMELOG
		echo IGNORELOG=$IGNORELOG
		echo ERRORSLOG=$ERRORSLOG
	fi
}

function show_times {
	time_diff "$TIMESTAMP" "$FULL" "elapsed for the last full backup"
}

function time_diff {
	local start end message
	start="$1"
	end="$2"
	message="$3"
	perl -e '
		sub num { return int(100 * shift)/100 }
		$start = -M "$ARGV[0]";
		$end = -M "$ARGV[1]";
		print join(" ", (num(24*($start - $end))), "hours $ARGV[2]\n");
	' "$start" "$end" "$message"

}

function check_space {
	local free needed
	free=`df "$BK_DIR/" | tail -1 | perl -pne 's{(\d+) \s+ \d+ \%}{$used = $1;''}xmsge; $_ = "$used\n"'`
	needed=`du "$FULL" | perl -pne 's{\A (\d+) .+}{$1\n}xmsg'`

	if perl -e 'exit($ARGV[0] < $ARGV[1] ? 1 : 0)' $needed $free ; then
		echo there is enough space available for backup
	else
		echo NOT OK need $needed but only $free is available.
		du -h "$FULL"
		df -h "$BK_DIR/"
		log_error "Error: not enough space available for full backup, need $needed, free $free. Will do a partial backup instead."
		partial_backup
		exit 0
	fi
}

function filter_logs {
	# make lists of filenames, files and directories from the backup
	perl -ne 'if (m{/ \s* \z}xms) { print } else { print STDERR }' "$LOG" > "$DIRLOG" 2> "$FILELOG"
	perl -pne 's{\A .+ /}{}xms' "$FILELOG" | sort | uniq > "$FILENAMELOG"

	# filter error log into ignored and relevant
	perl -ne '
		if (m{
			socket \s ignored
			| file \s is \s unchanged
			| Removing \s leading .+ from \s
			| $SOURCE : \s file \s changed \s as \s we \s read \s it
			}xms)
		{
			print
		}
		else
		{
			print STDERR
		}' "$ERRLOG" > "$IGNORELOG" 2> "$ERRORSLOG"
}

function say {
	local message
	message="$1"
	which notify > /dev/null && notify -t "$0" -m "$message"
}

function summary {
	local message
	echo Backup complete: $BACKUP
	echo From: $SOURCE
	ls -al "$BACKUP"
	message="`cat "$FILELOG" | wc -l` files backed up"
	say "$message"
	message="`cat "$DIRLOG" | wc -l` directories backed up"
	say "$message"
	message="`cat "$ERRORSLOG" | wc -l` errors"
	say "$message"
	message="`cat "$IGNORELOG" | wc -l` ignored warnings"
	say "$message"
	message="Disk usage on backup drive: `df -h $BK_DIR`"
	say "$message"
	message="Errors logged to $ERRORSLOG"
	say "$message"
	head $ERRORSLOG
	if [ `cat $ERRORSLOG | wc -l` != 0 ]; then
		log_error "Errors from backup"
	fi
}

function log_error {
	local message
	message="$1"
	echo "ERROR `date` $0:" >> "$HOME/warnings.log"
	echo "$message" >> "$HOME/warnings.log"
	if [ ! -z "$ERRORSLOG" ]; then
		cat $ERRORSLOG >> "$HOME/warnings.log"
	fi
}

function restore {
	# check existence of full backup

	[ -e "$FULL" ] || die 2 "there is no full backup to restore from: $FULL"

	echo restore $FIND
	RESTORE=./restore
	ARCHIVES=`find $BK_DIR -maxdepth 1 -newer "$FULL" -type f | grep ezbackup | grep \.tgz`
	ARCHIVES="$FULL $ARCHIVES"

	if [ $DEBUG == 1 ]; then
		echo RESTORE=$RESTORE
		echo ARCHIVES=$ARCHIVES
	fi

	[ -d "$RESTORE" ] || mkdir $RESTORE
	for archive in $ARCHIVES;
	do
		echo scanning $archive:
		tar xvzf $archive --directory $RESTORE --wildcards $FIND
	done
}

function do_backup {
	echo `date` $MODE backup
	config
	backup
	summary
	unlock
}

function do_restore {
	config
	restore
	unlock
}

if [ "$MODE" == "restore" ]; then
	[ -z "$FIND" ] && usage "you must provide a file pattern to restore from backup"

	do_restore
else
	do_backup
fi

exit 0

~/.BACKUP contents:
# configure backup variables
WHOSE=bcowgill

export BK_DIR=/data/$WHOSE/backup
export SOURCE=/home/$WHOSE
export NUM_PARTIALS=9

# crontab entry examples:
25 11,16 * * * $HOME/bin/ezbackup.sh > /tmp/$LOGNAME/crontab-ezbackup.log 2>&1

15 20,23 * * 1-5 $HOME/bin/ezbackup.sh > /tmp/$LOGNAME/crontab-ezbackup.log 2>&1
15 8,13,20 * * 6-7  $HOME/bin/ezbackup.sh > /tmp/$LOGNAME/crontab-ezbackup.log 2>&1

# touch-randomly.sh
# touch some files at random so partial backup test has something to do
while /bin/true;
do
	FILE=`find ~/Documents/test/unicode/ -type f | choose.pl`
	touch $FILE
	echo $FILE
	sleep 10
done;
