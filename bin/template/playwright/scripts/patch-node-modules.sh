#!/bin/bash
# A tool for debugging node module code by copying patched files or restoring the originals.

SM=vendor
EXT=js

NAME=playwright
MOD=playweright-core
NM=node_modules/$MOD/lib
SUBDIRS=" \
	client/page \
	client/harRouter \
	server/dispatchers/dispatcher \
	server/dispatchers/localUtilsDispatcher \
"

# patch.sh --undo
UNDO=$1

if [ -z "$UNDO" ]; then
	echo "Will patch your $NAME node_modules to diagnose or debug issues."
	echo 'use --undo parameter to restore node modules to originals.'
	echo "vendor/\*\*/\*.$EXT.orig is the original node_modules file from $MOD"
	echo "vendor/\*\*/\*.$EXT is the changed version with console logs and/or code fixes in it."
else
	echo "Will restore your $NAME node_modules."
fi

function maybePatch {
	if diff $ORIG $SAVE > /dev/null; then
		echo " copying patched version"
		echo "   cp $SM/$source.$EXT $FROM"
		cp "$SM/$source.$EXT" "$FROM"
	else
		echo "ABORT: Your saved file does not match the vendor file."
		echo " SAVE $SAVE"
		echo " VEND $ORIG"
		echo "You may have upgraded the $NAME modules and the patch may not be compatible with them. 1>&2"
		echo "You need to manually update the vendor/\*\*/\*.$EXT and .$EXT.orig files with new versions and reapply the console logs and/or code fixes."
		exit 1
	fi
}

for source in $SUBDIRS;
do
	echo " "
	echo $source.$EXT
	FROM="$NM/$source.$EXT"
	SAVE="$FROM.saved"
	ORIG="$SM/$source.$EXT.orig"
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
done
