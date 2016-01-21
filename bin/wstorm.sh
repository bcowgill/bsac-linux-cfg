#!/bin/bash
# Launch WebStorm sidestepping ibus keyboard issue
# https://youtrack.jetbrains.com/issue/IDEA-78860
#IBus 1.5.9
DIR=/tmp/$USER
LOG=$DIR/wstorm.log

TRUE=`ibus version | perl -ne 'if (m{IBus \s+ (\d+)\.(\d+)\.(\d+)}xms) { if ($1 <= 1 && $2 <= 5 && $3 < 11) { print "1"; exit 1; } else { print "0"; exit 0; } } '`

export IBUS_ENABLE_SYNC_MODE=$TRUE

mkdir -p $DIR 2> /dev/null
rm $LOG 2> /dev/null
wstorm > $LOG 2>&1 &
