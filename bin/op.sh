#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# some operation you want to monitor with watcher.sh
OUT=`mktemp`

if [ `pswide.sh -ef | grep 'updatedb-backup.sh' | grep -v grep | wc -l` == 1 ] ; then
	echo Full backup has finished, waiting for root password to update locate database.
fi

if ezbackup.sh check > $OUT 2>&1; then
	cat $OUT
fi

rm $OUT

df -k
