#!/bin/bash
# backup home dir configuration files to allow a GUI config
# change and then figure out which files changed and what the
# differences were.

DIR=workspace/backup/settings

# Not sure what kind of diffing capabilities are available so
# try to figure it out.
DIFF=`which diffmerge`
[ -z $DIFF ] && DIFF=`which vimdiff`
[ -z $DIFF ] && DIFF=`which colordiff`
[ -z $DIFF ] && DIFF=diff
if echo $DIFF | grep diffmerge ; then
	# Diffmerge can do directory diffs and no multi-windows
	DIFF="$DIFF --nosplash"
	DIRDIFF=1
	WAIT='&'
else
	# All else, manually to directory diffs and do everything
	# sequentially
	DIRDIFF=0
	WAIT=';'
fi

echo diff setup: $DIFF new old  $WAIT # DIRDIFF=$DIRDIFF

pushd $HOME > /dev/null

[ -d $DIR ] && rm -rf $DIR
mkdir -p $DIR
[ -d .kde ] && cp -r .kde $DIR/kde
[ -d .config ] && cp -r .config $DIR/config
# perforce merge tool
[ -d .p4merge ] && cp -r .p4merge $DIR/p4merge
# postgres and mysql configs backed up
cp .pg* .my* $DIR/

[ -d .thunderbird ] && cp -r .thunderbird $DIR/thunderbird

echo "Configuration files with changes:" > reconfigure.newer
touch reconfigure.timestamp

ls $DIR
echo Make some configuration changes in GUI - KDE/firefox now!
read WAIT

# Get list of files that have been changed, maybe due to the config changes you made.
find . -newer reconfigure.timestamp | grep -v reconfigure.newer >> reconfigure.newer
less reconfigure.newer

if [ $DIRDIFF == 1 ]; then
	[ -d $DIR/thunderbird ] && $DIFF .thunderbird/ $DIR/thunderbird $WAIT
	#diffmerge --nosplash .pgadmin3 $DIR/.pgadmin3 &
	[ -d $DIR/p4merge ] && $DIFF .p4merge/ $DIR/p4merge $WAIT
	[ -d $DIR/kde ]     && $DIFF .kde/     $DIR/kde     $WAIT
	[ -d $DIR/config ]  && $DIFF .config/  $DIR/config  $WAIT
else
	# Do manual directory diffing for known directories
	# This could be smarter by looking for the file in the backup dir.
	P1="$DIFF" P2="$DIR" perl -i -pne '
		unless (s{\A (?:\./)? \. (thunderbird|p4merge|kde|config) (.+) \n\z}
		{$ENV{P1} ".$1$2" "$ENV{P2}/$1$2"\n}xmsgi) {
			if (m{\A Configuration \s files \s with \s changes:}xms) { $_ = qq{\n}; }
			else { s{\A}{less }xms }
		};
		' reconfigure.newer
	source reconfigure.newer
fi

popd > /dev/null

