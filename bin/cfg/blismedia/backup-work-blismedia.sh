#!/bin/bash
# save some stuff to dropbox for work at home
DROP=~/Dropbox/WorkSafe/_tx/blismedia
#THUNDER=ryu9c8b3.default
MOZZ=eog6kquf.default
COMPANY=blismedia
HOMECFG=".gitconfig .viminfo .lesshist .bash_history \
   .charles.config .charles \
   .kde/Autostart .kde/env .kde/share .local/share \
   .config/autostart .config/TrollTech.conf \
   .config/VirtualBox VirtualBox* \
   .mozilla/firefox/$MOZZ/prefs.js .mozilla/firefox/$MOZZ/sessionstore.js .mozilla/firefox/$MOZZ/search.json .mozilla/firefox/$MOZZ/bookmarkbackups \
   .SourceGear* \
   .slickedit \
   .pg* .my* \
   .dropbox"
HOMECFG_EXCLUDE="--exclude=.local/share/baloo"

#  .thunderbird/$THUNDER/prefs.js .thunderbird/$THUNDER/session.json \
ROOTCFG="/etc/mtab /etc/fstab"
#ROOTCFG="/etc/X11/xorg.conf /etc/mtab /etc/fstab"
WORKCFG="workspace/.metadata"
PLAY="play/project42 play/schema play/graphviz play/mapping-with-jquery"
VSLICK_FILES='Downloads/[sS][eE]_*.*'

echo ======================================================================
date
mkdir -p $DROP
crontab -l > ~/bin/cfg/crontab-$HOSTNAME

pushd ~
mkdir -p workspace/backup
mkdir -p $DROP/vslick

cp $VSLICK_FILES $DROP/vslick

tar cvzf workspace/backup/$COMPANY-home-cfg.tgz $HOMECFG_EXCLUDE $HOMECFG $WORKCFG $ROOTCFG
popd

pushd ~/workspace
tar cvzf backup/$COMPANY-notes.tgz *.txt
tar cvzf backup/$COMPANY-bin.tgz bin/
tar cvzf backup/work-stuff.tgz $PLAY charles-config/

#cp ~/Documents/PhoenixYard*.pdf $DROP
cp backup/$COMPANY-notes.tgz $DROP
cp backup/$COMPANY-bin.tgz $DROP
cp backup/$COMPANY-home-cfg.tgz $DROP
cp backup/work-stuff.tgz $DROP

date
echo Backup complete: $DROP
ls -al $DROP
popd

