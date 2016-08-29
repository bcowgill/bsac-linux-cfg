#!/bin/bash
# Easy backup system just give source and destination. Will do a full backup
# and then partial backups of what changed since last backup.

#set -x

DEBUG=0
CFG=$HOME/.BACKUP
CMD=`basename $0`

if [ "$1" == '--debug' ]; then
	DEBUG=1
	shift
fi

MODE=${1:-partial}

SOURCE="$2"
BK_DIR="$3"
BK_DISK="$4"

if [ "$MODE" == "restore" ]; then
	FIND="$2"
	SOURCE="$3"
	BK_DIR="$4"
	BK_DISK="$5"
fi
if [ "$MODE" == "full" ]; then
	DO_FULL=1
fi

function usage {
	local message code
	message="$1"
	code=0
	[ ! -z "$message" ] && (code=1; echo $message; echo " ")
	echo usage:
	echo "$CMD [restore|full|partial] [restore-pattern] [source-dir] [backup-dir] [full-backup-disk]"
	echo " "
	echo Easy backup system. You provide a source-dir to backup and a backup-dir to store backups in.  Alternatively create a $CFG file which exports SOURCE, BK_DIR and BK_DISK environment variables.
	echo " "
	echo If the full option is provided a full backup is forced.
	echo " "
	echo If restoring you can specify a wildcard to get an entire directory.  It will restore to ./restore directory.  Specify the full relative path of the file to restore, not an absolute path.
	echo " "
	echo "If full backup disk (BK_DISK) setting is different to the partial backup directory (BK_DIR) then the full backup dir will not be automatically created and a full backup will only happen if the disk is present."
	exit $code
}

if [ "$MODE" == "--help" ]; then
	usage
fi

# lock the backup directory to prevent a second backup starting
function lock {
	LOCK_ERROR=1
	mkdir $BK_DIR/locked || die 1 "unable to lock in $BK_DIR"
	LOCK_ERROR=
	# on error during script, unlock
	trap 'error ${LINENO}' ERR
}

# unlock the backup directory so that another backup can happen
function unlock {
	rmdir $BK_DIR/locked > /dev/null
}

# terminate the program with a value and message. will unlock the directory
# unless $LOCK_ERROR is set
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
   echo "$CMD: terminated by error while in `pwd`"
   if [[ -n "$message" ]] ; then
      echo "on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
   else
      echo "on or near line ${parent_lineno}; exiting with status ${code}"
   fi
	unlock
   exit "${code}"
}

# read the program configuration from config file so command
# arguments can be omitted. also locks the directory if a backup will begin.
function config {
	if [ -z "$BK_DIR" ]; then
		[ -e "$CFG" ] && source $CFG

		[ -z "$BK_DIR" ] && usage "you must provide a source and destination on command line or in $CFG"
		[ -z "$SOURCE" ] && usage "you must provide a source and destination on command line or in $CFG"
	fi
	[ -z "$BK_DISK" ] && BK_DISK="$BK_DIR"

	[ -d $BK_DIR ] || mkdir -p "$BK_DIR"
	[ -d $SOURCE ] || usage "$SOURCE: SOURCE directory does not exist."
	[ -d $BK_DIR ] || usage "$BK_DIR: BK_DIR could not be created."

	if [ $DEBUG == 1 ]; then
		echo SOURCE=$SOURCE
		echo BK_DIR=$BK_DIR
		echo BK_DISK=$BK_DISK
	fi

	NUM_PARTIALS=${NUM_PARTIALS:-5}
	FULL=$BK_DISK/ezbackup.tgz
	FULL_SAVE=$BK_DISK/saved.full.tgz
	FULL_TIMESTAMP="$BK_DIR/full-backup.timestamp"
	LAST_PARTIAL=$BK_DIR/ezbackup.$NUM_PARTIALS.tgz
	ALL_PARTIALS=$BK_DIR/ezbackup.*.tgz
	ALL_PARTIAL_LOGS=$BK_DIR/*.*.log
	ALL_PARTIAL_TIMESTAMPS=$BK_DIR/partial.*.timestamp

	lock

	if [ "$BK_DIR" != "$BK_DISK" ]; then
		# if full backups are located on external disk...
		if [ ! -z "$DO_FULL" ]; then
			# and we are asked to do a full backup...
			if [ ! -d "$BK_DISK" ]; then
				# if full backup disk is not mounted, fallback to partial backup
				echo "WARNING: full backup disk $BK_DISK is not mounted, will do a partial backup."
			fi
			DO_FULL=
		fi
		if [ -z "$DO_FULL" ]; then
			# and we are doing a partial backup, we must have had a full backup
			if [ ! -e "$FULL_TIMESTAMP" ]; then
				die 2 "partial backup cannot proceed, there is no record of a full backup."
			fi
			if [ -e "$LAST_PARTIAL" ]; then
				# and we have done enough partial backups, check if we can do full
				if [ ! -d "$BK_DISK" ]; then
					# if full backup disk is not mounted, show a warning, but do partial
					log_error "WARNING: full backup is getting old, you should mount the backup disk.."
				fi
			fi
		fi
	else
		# else simple case all backups local
		if [ -z "$DO_FULL" ]; then
			# if doing a partial backup, change to full after the configured
			# number of partials or if we never have done a full backup
			[ -e "$LAST_PARTIAL" ] && DO_FULL=1
			[ ! -e "$FULL" ] && DO_FULL=1
		fi
	fi

	if [ $DEBUG == 1 ]; then
		echo DO_FULL=$DO_FULL
		echo FULL=$FULL
		echo FULL_SAVE=$FULL_SAVE
		echo FULL_TIMESTAMP=$FULL_TIMESTAMP
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
	TIMESTAMP="$FULL_TIMESTAMP"
	BACKUP="$FULL"
	define_logs

	[ -e "$FULL" ] && show_times && check_space
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
	which notify > /dev/null && notify -t "$CMD" -m "$message"
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
	echo "ERROR `date` $CMD:" >> "$HOME/warnings.log"
	echo "$message" >> "$HOME/warnings.log"
	if [ ! -z "$ERRORSLOG" ]; then
		cat $ERRORSLOG >> "$HOME/warnings.log"
	fi
}

function restore {
	# check existence of full backup

	[ -e "$FULL" ] || die 3 "there is no full backup to restore from: $FULL"

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
