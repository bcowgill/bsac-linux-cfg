#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] filename...

This will list the id3v2 genre along with the filename.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

See also id3v2 id3info ls-meta.sh get-meta.sh ls-music.sh id3v2-track.sh filter-id3.pl label-music.sh label-podcast.sh rename-podcast.sh
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
	echo ""
	usage 1
fi

while [ ! -z "$1" ]
do
	GENRE=`id3v2 --list "$1" | grep Genre: | perl -pne 's{\A.+Genre:\s+}{}xmsg'`
	GENRE=${GENRE:-nil}
	echo $GENRE: $1
	shift
done
