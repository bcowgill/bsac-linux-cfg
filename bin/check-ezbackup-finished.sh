#!/bin/bash
function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?]

This will check if full backup has finished yet -- to be used with alarm-if.sh

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

See also alarm-if.sh, alarm.sh, mynotify.sh, ezbackup.sh

Example:

alarm-if.sh check-ezbackup-finished.sh
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

if [ `pswide.sh -ef | grep 'updatedb-backup.sh' | grep -v grep | wc -l` == 1 ] ; then
	echo OK, full backup has finished, waiting for root password to update locate database.
	exit 0
fi
if [ `pswide.sh -ef | grep 'ezbackup.sh full' | grep -v grep | wc -l` == 0 ] ; then
	echo OK, full backup has finished.
	exit 0
fi
exit 1
