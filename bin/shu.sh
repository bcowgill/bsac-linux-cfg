#!/bin/bash
# silence the crontab launched cuckoo clock if running.
# and the birdsong if playing.
#set -x
#ps -ef | grep cuckoo
#echo ===

SCREENSHOTS=$HOME/_DELETE_TO_STOP_SCREENSHOTS
BIRDS=$HOME/d/Music/_Ringtones/birdsong/_DELETE_TO_SILENCE_THE_BIRDSONG_

[ -e "$BIRDS" ] && rm "$BIRDS"
[ -e "$SCREENSHOTS" ] && rm "$SCREENSHOTS"
PID=`ps -ef | grep bin/cuckoo.sh | grep -vE 'crontab|grep' | perl -pne 's{\A\s*}{}xmsg; @x=split(/\s+/); $_ = $x[1]'`
echo PID=$PID
if [ ! -z "$PID" ]; then
	ps -p $PID
	slay.sh $PID
fi

#  502 93688 93685   0 10:58am ??         0:00.01 /bin/sh -c $HOME/bin/cuckoo.sh "" 1 > /tmp/$LOGNAME/crontab-cuckoo.log 2>&1
#  502 93693 93688   0 10:58am ??         0:00.01 /bin/bash /Users/bcowgill/bin/cuckoo.sh  1
#  502 93783 93779   0 10:58am ttys002    0:00.00 grep cuckoo
