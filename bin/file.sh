#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

function usage {
	local code
	code=$1
	echo "
$(basename $0) [--help|--man|-?] one file only

This will use the file or mimetype command to show both mime and file information.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

The output will have the mime type and encoding displayed before the usual file information.

file.sh: text/x-shellscript; charset=us-ascii; Bourne-Again shell script, ASCII text executable

See also file, mimetype, whatsin.sh, filter-file.pl, ls-types.sh

Example:

	If a file name is single spaced:

	file.sh a file name with spaces.txt
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

if [ "x$OSTYPE" == "xdarwin16" ]; then
	# Mac we can only get mime type, not encoding.
	MIME=`mimetype --output-format="%m" "$*"`
	ERR=$?
else
	MIME=`file --mime-type --mime-encoding "$*"`
	ERR=$?

fi

if [ $ERR != 0 ]; then
	exit $ERR
fi
echo $MIME\; `file "$*" | perl -pne 's{\A.+:\s+}{}xms'`
