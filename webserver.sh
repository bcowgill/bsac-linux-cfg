#!/bin/bash
# Use python to fire up a simple web server to serve content

PORT=$1
DOCROOT=$2
HTTP_MOD=SimpleHTTPServer
# for python 3.0+
#HTTP_MOD=http.server

if [ "x$PORT" == "x" ]; then
   PORT=9999
fi

if [ "x$DOCROOT" == "x" ]; then
   DOCROOT=.
fi

[ ! -d /tmp/$USER ] && mkdir -p /tmp/$USER
LOG=/tmp/$USER/webserver-$PORT.log
pushd $DOCROOT
rm $LOG
(echo Serving content from `pwd`; echo on url-port http://localhost:$PORT; echo logging to $LOG) | tee $LOG
python -m $HTTP_MOD $PORT >> $LOG 2>&1 &
sleep 2
ps -ef | grep python | grep $HTTP_MOD
wget --output-document=/dev/null http://localhost:$PORT/favicon.ico
popd

