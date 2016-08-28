# some operation you want to monitor with watcher.sh
if [ -e /media/me/ELEMENTS-2TB ]; then
	ps -ef | egrep \\bcp\\b
	df -h /media/me/ELEMENTS-2TB
fi
if ps -ef | egrep \\bcvzf\\b; then
	ls -al /data/me/backup/ezbackup/*.tgz
fi
