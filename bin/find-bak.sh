#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] option

Find all temporary or backup files beneath current directory.

option  A single option for the find command. default is -print
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

Will ignore files within node_modules and .git directory.
Shows common editor backup files or temporary files created by git.

See also find-git.sh clean-git.sh clean.sh

Example:

Find and then delete the backup files.

$cmd -delete
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

PRINT=
if [ -z "$1" ]; then
	PRINT=-print
fi

find . \( \
	-name .tmp \
	-o -name .git \
	-o -name .idea \
	-o -name node_modules \
	-o -name bower_components \
	-o -name dist \
	-o -name coverage \
\) \
-prune -o \( \
	-iname '*.bak' \
	-o -name '*.swp' \
	-o -name '*.kate-swp' \
	-o -name '*~' \
	-o -name '*.rej' \
	-o -name '*.RESTORE' \
	-o -name '*_REMOTE_*' \
	-o -name '*_LOCAL_*' \
	-o -name '*_BACKUP_*' \
	-o -name '*_BASE_*' \
	-o -name '.#*' \
	-o -name '#*#$' \
	-o -name '*.orig' \
	-o -name '*.not' \
	-o -name '*.hold' \
\) $* $PRINT
# -o -name '*.orig'
# -o -name '*~Stashed changes'
