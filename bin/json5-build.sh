#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

DEBUG=${DEBUG}
FORCE=${FORCE}

AGAIN="$0"
FILE="$1"
SRC=json5
EXT=json
# Use tabs to indent .json file
OPTS="--space t"

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] [$SRC-file]

Find all .$SRC files in the current directory tree and create .$EXT versions if necessary.

FORCE   environment variable set to 1 to force building the .$EXT file from the .$SRC
DEBUG   environment variable set to 1 to skip the actual build step.
$SRC-file  if a single file is provided it tries to build the .$EXT from it.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

Will only create the .$EXT file if the .$SRC is newer or the .$EXT doesn't exist.
Will run prettier on the output if available.
Will ignore files within node_modules and .git directory and others.

See also auto-build.sh, json5, prettier

Examples:

	Automatically update the .$EXT files when things change.

	auto-build.sh json5-build.sh
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

if [ -z "$FILE" ]; then
	BUILD='./node_modules/.bin/json5'
	if [ ! -x "$BUILD" ]; then
		BUILD=`which json5 2> /dev/null`
		if [ ! -x "$BUILD" ]; then
			echo You need to have json5 command on your path for this to work.
			exit 1
		fi
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
		-iname '*.'$SRC \
	\) -exec "$AGAIN" {} \;
else
	DIR=`dirname "$FILE"`
	JSON=`basename "$FILE" ".$SRC"`
	OUT="$DIR/$JSON.$EXT"
	# Build if file not created or if source is newer than target
	if [ ! -z "$FORCE" ] || [ ! -e "$OUT" ] || [ "$FILE" -nt "$OUT" ]; then
		echo building "$OUT" from "$FILE"
		if [ -z "$DEBUG" ]; then
			$BUILD $OPTS "$FILE" --out-file "$OUT"

			PRETTY='./node_modules/.bin/prettier'
			if [ ! -x "$PRETTY" ]; then
				PRETTY=`which prettier 2> /dev/null`
			fi
			if [ -x "$PRETTY" ]; then
				$PRETTY --write "$OUT"
			fi
		fi
	fi
fi
