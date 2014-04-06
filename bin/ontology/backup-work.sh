#!/bin/bash
# save some stuff to dropbox for work at home
DROP=~/Dropbox/WorkSafe/_tx/ontology
THUNDER=ryu9c8b3.default
MOZZ=19o4iihs.default
HOMECFG=".gitconfig .viminfo .lesshist .bash_history \
   .charles.config .charles \
   .kde/Autostart .kde/env .kde/share .local/share \
   .config/autostart .config/TrollTech.conf \
   .config/VirtualBox VirtualBox* \
   .Ontology_Modeller_Workspace \
   .thunderbird/$THUNDER/prefs.js .thunderbird/$THUNDER/session.json \
   .mozilla/firefox/$MOZZ/prefs.js .mozilla/firefox/$MOZZ/sessionstore.js .mozilla/firefox/$MOZZ/search.json .mozilla/firefox/$MOZZ/bookmarkbackups \
   .SourceGear* \
   .dropbox"
ROOTCFG="/etc/X11/xorg.conf /etc/mtab /etc/fstab"
WORKCFG="workspace/.metadata"


echo ======================================================================
date
mkdir -p $DROP
crontab -l > ~/bin/cfg/crontab-$HOSTNAME

pushd ~
mkdir -p workspace/backup

tar cvzf workspace/backup/ontology-home-cfg.tgz $HOMECFG $WORKCFG $ROOTCFG
popd

pushd ~/workspace
tar cvzf backup/ontology-notes.tgz *.txt
tar cvzf backup/ontology-bin.tgz bin/
tar cvzf backup/work-visualise.tgz play/ charles-config/ projects/lib-cca
tar cvzf backup/ontology-dataflow.tgz ontoscope/bundles/web.ontoscope.test/package.json \
   ontoscope/bundles/web.ontoscope.test/Gruntfile.js \
   ontoscope/bundles/web.ontoscope.test/qunit-testing \
   ontoscope/bundles/web.ontoscope/html/com/ontologypartners/web/ontoscope/components/dataflow

cp ~/Documents/PhoenixYard*.pdf $DROP
cp backup/ontology-notes.tgz $DROP
cp backup/ontology-bin.tgz $DROP
cp backup/ontology-home-cfg.tgz $DROP
cp backup/work-visualise.tgz $DROP

date
echo Backup complete: $DROP
ls -al $DROP
popd

