#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?]

This will read lines from standard input and output them in random order.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

See also choose.pl, cp-random.pl, random-ringtone.sh, randomize-urls.sh, random-text.sh, random-desktop.sh

Example:

Create a montage of some images in random order:

	ORDER=`ls image*.jpg | random-order.sh`
	montage -mode concatenate -tile 7x $ORDER -geometry +0+0 montage-all.jpg

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

perl -pne '$random = rand(); $_ = "$random:$_"'| sort | perl -pne 's{\A.+?:}{}xms'

exit 0
