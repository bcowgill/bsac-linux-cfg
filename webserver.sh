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

pushd $DOCROOT
echo Serving content from `pwd` on http://localhost:$PORT
python -m SimpleHTTPServer $PORT &
# For python 3.0+
#python -m http.server $PORT &
ps -ef | grep python | grep SimpleHTTPServer
popd

