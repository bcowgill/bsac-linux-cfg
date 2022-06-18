# see also updatedb-backup.sh updatedb.sh locate lokate.sh updatedb
BACKUP=/media/me/ADATA-4TB
DB=/var/lib/mlocate/mlocate-ADATA-4TB.db

locate --database $DB $*
