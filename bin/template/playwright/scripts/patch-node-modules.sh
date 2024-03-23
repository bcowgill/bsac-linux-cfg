#!/bin/bash
# A tool for debugging node module code by copying patched files or restoring the originals.

TOP=__vendor__
EXT=js
LOCK=package-lock.json

NAME=playwright
MOD=playwright-core
SM=__vendor__/$MOD
NM=node_modules/$MOD/lib
SUBDIRS=" \
	client/page \
	client/harRouter \
	server/dispatchers/dispatcher \
	server/dispatchers/localUtilsDispatcher \
"

# patch.sh --setup  # run after an npm update of the module.
# patch.sh --undo
UNDO=$1

if [ ! -d "$SM" ]; then
	UNDO=--setup
fi
if [ "$UNDO" == "--setup" ]; then
	mkdir -p $SM
	grep $MOD $LOCK | grep -E '"[0-9.]+"' > $SM/versions.txt
	echo "Will create $SM dir and copy of your $NAME node_modules there for patching."
	cat $SM/versions.txt
	echo "$SM/\*\*/\*.$EXT.orig is the original node_modules file from $MOD"
	echo "$SM/\*\*/\*.$EXT is the changed version with console logs and/or code fixes in it."
else
	if [ -z "$UNDO" ]; then
		echo "Will patch your $NAME node_modules to diagnose or debug issues."
		echo 'use --undo parameter to restore node modules to originals.'
		echo "$SM/\*\*/\*.$EXT.orig is the original node_modules file from $MOD"
		echo "$SM/\*\*/\*.$EXT is the changed version with console logs and/or code fixes in it."
	else
		echo "Will restore your $NAME node_modules."
	fi
fi

function maybePatch {
	if diff $ORIG $SAVE > /dev/null; then
		echo " copying patched version"
		echo "   cp $PATCH $FROM"
		cp "$PATCH" "$FROM"
	else
		echo "ABORT: Your saved file does not match the $SM file."
		echo " SAVE $SAVE"
		echo " VEND $ORIG"
		echo "You may have upgraded the $NAME modules and the patch may not be compatible with them." 1>&2
		echo "Patched files are from version:"
		cat $SM/versions.txt
		echo "Package version is currently:"
		grep $MOD $LOCK | grep -E '"[0-9.]+"'
		echo "You need to manually update the $SM/\*\*/\*.$EXT and .$EXT.orig files with new versions and reapply the console logs and/or code fixes."
		echo "You can use the --setup option to begin this process."
		exit 1
	fi
}

for source in $SUBDIRS;
do
	echo " "
	echo $source.$EXT
	PATCH="$SM/$source.$EXT"
	FROM="$NM/$source.$EXT"
	SAVE="$FROM.saved"
	ORIG="$SM/$source.$EXT.orig"
	DIR=`dirname $PATCH`
	if [ "$UNDO" == "--setup" ]; then
		mkdir -p "$DIR" > /dev/null
		echo " saving original"
		echo "   cp $FROM $SAVE"
		cp "$FROM" "$SAVE"
		echo "   cp $FROM $ORIG"
		cp "$FROM" "$ORIG"
		echo " touching patch file to begin"
		touch "$PATCH"
	else
		if [ -e $SAVE ]; then
			echo " is saved..."
			if [ -z "$UNDO" ]; then
				maybePatch
			else
				echo " undoing the patch..."
				echo "   cp $SAVE $FROM"
				cp "$SAVE" "$FROM"
			fi
		else
			echo " saving original"
			echo "   cp $FROM $SAVE"
			cp "$FROM" "$SAVE"
			if [ -z "$UNDO" ]; then
				maybePatch
			else
				echo "Patch did not need to be undone, there was none."
			fi
		fi
	fi
done
