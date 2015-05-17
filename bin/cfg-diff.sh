#!/bin/bash
# backup home dir configuration files to allow a GUI config
# change and then figure out which files changed and what the
# differences were.

DIR=workspace/backup/settings

DIFF=`which diffmerge`
[ -z $DIFF ] && DIFF=`which vimdiff`
[ -z $DIFF ] && DIFF=`which colordiff`
[ -z $DIFF ] && DIFF=diff
if echo $DIFF | grep diffmerge ; then
	DIFF="$DIFF --nosplash"
	WAIT='&'
else
	WAIT=';'
fi

echo diff setup: $DIFF new old  $WAIT

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

find . -newer reconfigure.timestamp >> reconfigure.newer
cat reconfigure.newer | grep -v reconfigure.newer | less

[ -d $DIR/thunderbird ] && $DIFF .thunderbird/ $DIR/thunderbird $WAIT
#diffmerge --nosplash .pgadmin3 $DIR/.pgadmin3 &
[ -d $DIR/p4merge ] && $DIFF .p4merge/ $DIR/p4merge $WAIT
[ -d $DIR/kde ] && $DIFF .kde/ $DIR/kde $WAIT
[ -d $DIR/config ] && $DIFF .config/ $DIR/config $WAIT

popd > /dev/null

