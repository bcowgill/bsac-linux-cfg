#!/bin/bash
# save some stuff to dropbox for work at home
DROP=~/Dropbox/WorkSafe/_tx/ontology
HOMECFG=".gitconfig .viminfo .lesshist .bash_history .charles.config \
   .charles .kde/Autostart .kde/env .kde/share .local/share \
   .config/autostart .config/TrollTech.conf .Ontology_Modeller_Workspace .dropbox"
ROOTCFG="/etc/X11/xorg.conf"
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
tar cvzf backup/work-visualise.tgz play/ charles-config/

cp ~/Documents/PhoenixYard*.pdf $DROP
cp backup/ontology-notes.tgz $DROP
cp backup/ontology-bin.tgz $DROP
cp backup/ontology-home-cfg.tgz $DROP
cp backup/work-visualise.tgz $DROP

date
echo Backup complete: $DROP
ls -al $DROP
popd

