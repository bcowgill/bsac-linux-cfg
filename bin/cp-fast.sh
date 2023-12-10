#!/bin/bash
# https://lotoftech.com/the-faster-and-safer-way-to-copy-files-in-linux-than-cp/

FROM="$1"
TO="$2"
NEW="$3"

if [ -z "$FROM" ]; then
	echo fast copy files or directory
	echo You must provide a source to copy. Either a huge file or a large directory.
	exit 1
fi
if [ -z "$TO" ]; then
	echo fast copy files or directory from "$FROM"
	echo You must provide a destination for the copy and optionally a new directory name to create.
	exit 2
fi
if [ ! -z "$NEW" ]; then
	TO="$TO/$NEW"
	mkdir -p "$TO"
fi


if [ -d "$FROM" ]; then
	echo fast copy directory from "$FROM" to "$TO"
	if which pv > /dev/null; then
		(cd "$FROM" && tar cf - .) | pv | (cd "$TO" && tar xvf -)
	else
		(cd "$FROM" && tar cf - .) | (cd "$TO" && tar xvf -)
	fi
else
	echo fast copy huge file from "$FROM" to "$TO"
	if which pv > /dev/null; then
		tar cf - "$FROM" | pv | (cd "$TO" && tar xvf -)
	else
		tar cf - "$FROM" | (cd "$TO" && tar xvf -)
	fi
fi
