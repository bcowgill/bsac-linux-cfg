#!/bin/bash
# Search all mlocate databases for files
# see also locatebk.sh, updatedb-backup.sh, updatedb.sh, lokate.sh, locate, updatedb, find
DBDIR=/var/lib/mlocate

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] [locate command options...]

This will search all mlocate*.db files in $DBDIR using the options specified.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

Use the command locate --help to see the locate command options that can be used.

See also scan-tree.sh, locatebk.sh, lokate, updatedb-backup.sh, updatedb.sh, locate, find

Example:

Find all your birthday photos in indexed backup databases.

$cmd -i birthday | filter-pics
"
	exit $code
}
if [ "$1" == "--help" ]; then
	usage 0
fi
if [ "$1" == "--man" ]; then
	usage 0
fi
if [ "$1" == "-?" ]; then
	usage 0
fi

for DB in `ls -1 $DBDIR/mlocate*.db`; do
	locate --database $DB $*
done
