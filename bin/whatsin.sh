#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine
# TODO whatsin -- random sample of N per directory or a % of files in directory, or one of each file extension
function usage {
	local code
	code=$1
	echo "
$(basename $0) [--help|--man|-?] directory...

This will show what kind of files are within a directory tree.

--raw      Shows just the raw output from the file command.
--clean    Shows touched up output from filter-file.pl command.
--mime     Shows mime types only from the file command.
--combine  Shows mime types and file description using file.sh.
--summary  Shows a summary of the files from the filter-file.pl command.
--list     Shows only a summary of the files in list from from the filter-file.pl command.
--man      Shows help for this tool.
--help     Shows help for this tool.
-?         Shows help for this tool.

See also file, file.sh, filter-file.pl, ls-types.sh, ls-types.pl

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
if [ "$1" == "--mime" ]; then
	shift
	find $* -type f -exec file --mime-type --mime-encoding {} \;
	exit $?
fi
if [ "$1" == "--combine" ]; then
	shift
	find $* -type f -exec file.sh {} \;
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
