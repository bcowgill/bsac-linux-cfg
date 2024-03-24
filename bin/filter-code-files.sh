#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?]

This will filter a file or grep listing and suppress any files which relate to software development, leaving only asset files displayed.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

This will filter out file names which are source code or configuration files

See also filter-built-files.sh, filter-code-files.sh, filter-web.sh, filter-sounds.sh, filter-images.sh, filter-videos.sh, filter-indents.sh, filter-punct.sh and other filter- based tools.

Example:

	Find non-code assets in the src/ directory tree.

find src -type f | filter-code-files.sh

	Find non-code files and exclude build directories.

find . -type f | filter-built-files.sh | filter-code-files.sh
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
	| egrep -vi '\.(asm?|c|cs|cpp|java|jsp|exs?)(:|"|\s*$)' \
	| egrep -vi '\.(txt|log1?|lst|saved|orig|sample|out|base|old|new|xxx|yyy|debug|warn|timestamp|clean|snap(shot)?|std(out|err))(:|"|\s*$)' \
	| egrep -v '\.(_.+|apdisk|DS_Store|Trash|Trash-.+|Trashes|Spotlight-V100|fseventsd|TemporaryItems)(:|"|\s*$)' \
	| egrep -vi '(~|_(REMOTE|LOCAL|BACKUP|BASE)_.+?|#.+#|\.(bak|swp|kate-swp|rej|RESTORE|orig|saved|not|hold|#.+?))(:|"|\s*$)' \
	| egrep -vi '\.(fortune|dat|csv|meta|es[56]|[cem]js|linux|mac|all|rc)'  # <== move/remove these
	# .stdout .stderr .snap .snapshot .timestamp .debug .warn

# source code files for compiled languages
# miscellaneous text logs and other dev files
# various OS specific files to ignore
# various backup file names in use by people and editors

# Backup files and GIT temporary files
# (~|_(REMOTE|LOCAL|BACKUP|BASE)_.+?|#.+#|\.(bak|swp|kate-swp|rej|RESTORE|orig|saved|not|hold|#.+?))(:|"|\s*$)

if [ $? != 0 ]; then
	usage 1
fi
