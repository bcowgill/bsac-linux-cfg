#!/bin/bash
# https://lotoftech.com/the-faster-and-safer-way-to-copy-files-in-linux-than-cp/

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] huge to [new]

This will rapidly copy a huge file or directory tree to another device.

huge    The huge file name or directory with loads of files which must be copied.
to      The other device location to copy the file or directory to.
new     optional. The new directory to create on the other device.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

While copying it will show a progress bar if possible using the pv command.

See also cp-random.pl mv-to-tar.sh mv-to-zip.sh

Example:

	copy the big directory big-dir to the /mnt/external device, creating the big-dir directory showing start and end time.

datestamp.sh; $cmd big-dir /mnt/external big-dir; datestamp.sh
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
if echo "$*" | grep -- "--" > /dev/null; then
	echo "unknown parameter provided, please study the command usage below."
	usage 1
fi

FROM="$1"
TO="$2"
NEW="$3"

if [ -z "$FROM" ]; then
	echo You must provide a source to copy. Either a huge file or a large directory.
	usage 2
fi
if [ -z "$TO" ]; then
	echo fast copy files or directory from "$FROM"
	echo You must provide a destination for the copy and optionally a new directory name to create.
	usage 3
fi
if [ ! -e "$TO" ]; then
	echo $TO: does not exist.  You must provide an existing destination for the copy and optionally a new directory name to create under it.
	exit 4
fi
if [ ! -z "$NEW" ]; then
	TO="$TO/$NEW"
	mkdir -p "$TO"
fi

if [ -d "$FROM" ]; then
	echo fast copy directory from "$FROM" to "$TO"
	if which pv > /dev/null; then
		(cd "$FROM" && tar cf - .) | pv | (cd "$TO" && tar xf -)
	else
		(cd "$FROM" && tar cf - .) | (cd "$TO" && tar xvf -)
	fi
else
	if [ ! -e "$FROM" ]; then
		echo "$FROM: does not exist.  You must provide an existing file or directory to copy."
		exit 5
	fi
	echo fast copy huge file from "$FROM" to "$TO"
	if which pv > /dev/null; then
		tar cf - "$FROM" | pv | (cd "$TO" && tar xf -)
	else
		tar cf - "$FROM" | (cd "$TO" && tar xvf -)
	fi
fi
