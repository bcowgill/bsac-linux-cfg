#!/bin/bash
# Make a backup copy of users windows files like Desktop icons, etc

source setup-win.sh

function backup_user {
	local archive
	archive="$1"

	tar cvzf $archive \
		*.lnk \
		Desktop \
		Favorites \
		Links \
		Searches \
		AppData/Roaming/Microsoft/Windows/Recent \
		AppData/Roaming/Microsoft/Windows/SendTo \
		"AppData/Roaming/Microsoft/Windows/Start Menu" \
		AppData/Roaming/Microsoft/Windows/Themes \
		Documents \
		Pictures \
		Music \
		Videos
}

echo " "
echo "======================================================="
echo " "
echo Backing up users important windows files to "$USERBAKDIR"
pushd "$USERUSERPROFILE"
	backup_user $USERBAKDIR/c-users-files.tgz
popd

echo " "
echo "======================================================="
echo " "
echo Backing up roots important windows files to "$ROOTBAKDIR"
pushd "$USERPROFILE"
	touch nothing.lnk
	backup_user $ROOTBAKDIR/c-root-files.tgz
popd

echo " "
echo "======================================================="
echo " "
echo Backing up important windows files to "$ROOTBAKDIR"
pushd $WINDIR
tar cvzf $ROOTBAKDIR/c-windows-files.tgz \
	Fonts \
	Media \
	Resources \
	Globalization/MCT \
	Web
popd

pushd "$ProgramData"
tar cvzf $ROOTBAKDIR/c-programdata-files.tgz \
	Desktop \
	"Start Menu" \
	"Microsoft/Windows/Start Menu" \
	Microsoft/Windows/Ringtones
popd

