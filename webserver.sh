#!/bin/bash
# Use python to fire up a simple web server to serve content

PORT=$1
DOCROOT=$2

if [ "x$PORT" == "x" ]; then
   PORT=9999
fi

if [ "x$DOCROOT" == "x" ]; then
   DOCROOT=.
fi

[ ! -d /tmp/$USER ] && mkdir -p /tmp/$USER
LOG=/tmp/$USER/bcowgill-webserver-$PORT.log
pushd $DOCROOT
echo Serving content from `pwd` on http://localhost:$PORT logging to $LOG
rm $LOG
python -m SimpleHTTPServer $PORT > $LOG 2>&1 &
# For python 3.0+
#python -m http.server $PORT &
ps -ef | grep python | grep SimpleHTTPServer
popd

