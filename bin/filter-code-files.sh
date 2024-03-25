#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?]

This will filter a list of file names or grep output and suppress any files which relate to software development, leaving only asset files displayed.

path    File names to process. If omitted then standard input will be scanned.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

This will filter out file names which are source code or configuration files

See also filter-built-files.sh, filter-code-files.sh, filter-web.sh, filter-sounds.sh, filter-images.sh, filter-videos.sh, filter-indents.sh, filter-punct.sh and other filter- based tools

See the online file extension database https://fileinfo.com/extension/wav

Example:

	Find non-code assets in the src/ directory tree.

find src -type f | $cmd

	Find non-code files and exclude build directories.

find . -type f | filter-built-files.sh | $cmd
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

filter-configs.sh -v $* \
	| filter-scripts.sh -v \
	| filter-min.sh \
	| filter-web.sh -v \
	| filter-source.sh -v \
	| filter-osfiles.sh -v \
	| filter-bak.sh -v \
	| egrep -vi '\.(txt|log1?|lst|saved|orig|sample|out|base|old|new|xxx|yyy|debug|warn|timestamp|clean|snap(shot)?|std(out|err))(:|"|\s*$)' # .txt .log .log1 .lst .saved .orig .sample .out .base .old .new .xxx .yyy .stdout .stderr .snap .snapshot .clean .timestamp .debug .warn
# miscellaneous text logs and other dev files
#	| egrep -vi '\.(fortune|dat|csv|meta|es[56]|[cem]js|linux|mac|all|rc)'  # <== move/remove these
if [ $? != 0 ]; then
	usage 1
fi