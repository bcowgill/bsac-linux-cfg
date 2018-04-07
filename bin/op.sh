# some operation you want to monitor with watcher.sh
OUT=`mktemp`
if ezbackup.sh check > $OUT 2>&1; then
	cat $OUT
fi
rm $OUT

df -k
