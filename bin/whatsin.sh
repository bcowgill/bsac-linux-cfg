#!/bin/bash
# WINDEV tool useful on windows development machine
# TODO whatsin -- random sample of N per directory or a % of files in directory, or one of each file extension
function usage {
	local code
	code=$1
	echo "
$(basename $0) [--help|--man|-?] directory...

This will show what kind of files are within a directory tree.

--raw   Shows just the raw output from the file command.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

See also file, ls-types.sh, ls-types.pl

...
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

if [ "$1" == "--raw" ]; then
	shift
	find $* -type f -exec file {} \;
	exit $?
fi
if [ "$1" == "--clean" ]; then
	shift
	find $* -type f -exec file {} \; | filter-file.pl --raw
	exit $?
fi
if [ "$1" == "--summary" ]; then
	shift
	find $* -type f -exec file {} \; | filter-file.pl --summary
	exit $?
fi
if [ "$1" == "--list" ]; then
	shift
	find $* -type f -exec file {} \; | filter-file.pl --summary --list --list
	exit $?
fi

find $* -type f -exec file {} \; | filter-file.pl

exit 0
