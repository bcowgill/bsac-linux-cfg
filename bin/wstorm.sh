#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# Launch WebStorm sidestepping ibus keyboard issue
# https://youtrack.jetbrains.com/issue/IDEA-78860
#IBus 1.5.9
DIR=/tmp/$USER
LOG=$DIR/wstorm.log

TRUE=`ibus version | perl -ne 'if (m{IBus \s+ (\d+)\.(\d+)\.(\d+)}xms) { if ($1 <= 1 && $2 <= 5 && $3 < 11) { print "1"; exit 1; } else { print "0"; exit 0; } } '`


export IBUS_ENABLE_SYNC_MODE=$TRUE

mkdir -p $DIR 2> /dev/null
rm $LOG 2> /dev/null
echo IBUS_ENABLE_SYNC_MODE=$TRUE > $LOG
ls -al /usr/local/bin/wstorm >> $LOG
ls -al $HOME/bin/WebStorm >> $LOG
ls -al $HOME/.WebStorm* >> $LOG
ls -al $HOME/Downloads/check-system | grep WebStorm >> $LOG
(which nvmgo.sh && nvmgo.sh) >> $LOG
export CHROME_BIN=`which chromium-browser`
export NODE=`which node`
wstorm >> $LOG 2>&1 &
