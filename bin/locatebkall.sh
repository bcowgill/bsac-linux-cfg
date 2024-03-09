#!/bin/bash
# Search all mlocate databases for files
# see also locatebk.sh updatedb-backup.sh updatedb.sh locate lokate.sh updatedb
DBDIR=/var/lib/mlocate
for DB in `ls -1 $DBDIR/mlocate*.db`; do
	locate --database $DB $*
done
