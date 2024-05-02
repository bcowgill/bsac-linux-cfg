#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] filename...

This will list the id3v2 track number along with the filename.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

See also id3v2 id3info ls-meta.sh get-meta.sh ls-music.sh id3v2-ls.sh filter-id3.pl label-music.sh label-podcast.sh rename-podcast.sh

Examples

	Find mp3 files in the output directory and list their track numbers.

$cmd \`find output/ -type f | grep mp3 | sort\`

	If there are files with spaces in their names:

find output/ -type f | grep mp3 | perl -ne 'chomp; \$_ = qq{$cmd \"\$_\"\\n}; system(\$_);'
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
	TRK=`id3v2 --list "$1" | grep Track: | perl -pne 's{\A.+Track:\s+}{}xmsg'`
	TRK=${TRK:-nil}
	echo $TRK: $1
	shift
done
