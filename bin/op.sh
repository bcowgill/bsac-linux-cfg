# some operation you want to monitor with watcher.sh
#ps -ef | egrep \\bcp\\b
if ps -ef | egrep \\bcvzf\\b; then
	ls -al /data/me/backup/ezbackup/*.tgz
fi
