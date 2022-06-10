#!/bin/bash
# silence the crontab launched cuckoo clock if running.
#set -x
#ps -ef | grep cuckoo
#echo ===
PID=`ps -ef | grep bin/cuckoo.sh | grep -vE 'crontab|grep' | perl -pne 's{\A\s*}{}xmsg; @x=split(/\s+/); $_ = $x[1]'`
echo PID=$PID
if [ ! -z "$PID" ]; then
	ps -p $PID
	slay.sh $PID
fi

#  502 93688 93685   0 10:58am ??         0:00.01 /bin/sh -c $HOME/bin/cuckoo.sh "" 1 > /tmp/$LOGNAME/crontab-cuckoo.log 2>&1
#  502 93693 93688   0 10:58am ??         0:00.01 /bin/bash /Users/bcowgill/bin/cuckoo.sh  1
#  502 93783 93779   0 10:58am ttys002    0:00.00 grep cuckoo
