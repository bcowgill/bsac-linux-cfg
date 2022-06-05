#!/bin/bash
# silence the cuckoo clock if running.
#ps | grep cuckoo
#set -x
PID=`ps | grep bin/cuckoo.sh | grep -v grep | perl -pne 's{\A\s*}{}xmsg; @x=split(/\s+/); $_ = $x[0]'`
if [ ! -z "$PID" ]; then
	ps -p $PID
	slay.sh $PID
fi
