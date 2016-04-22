#!/bin/bash
# Use python to fire up a simple web server to serve content
# recognize the node npm config.port value if present and use that.

PORT=$1
DOCROOT=$2
HTTP_MOD=SimpleHTTPServer
# for python 3.0+
#HTTP_MOD=http.server

if [ -z "$PORT" ]; then
	if [ -z "$npm_package_config_port" ]; then
		PORT=9999
	else
		echo package.json config.port setting=$npm_package_config_port
		PORT=$npm_package_config_port
	fi
fi

if [ "x$DOCROOT" == "x" ]; then
	DOCROOT=.
fi

[ ! -d /tmp/$USER ] && mkdir -p /tmp/$USER
LOG=/tmp/$USER/webserver-$PORT.log
pushd $DOCROOT
[ -f $LOG ] && rm $LOG
(echo Serving content from `pwd`; echo on url-port http://localhost:$PORT; echo logging to $LOG) | tee $LOG
python -m $HTTP_MOD $PORT >> $LOG 2>&1 &
sleep 2
ps -ef | grep python | grep $HTTP_MOD
wget --output-document=/dev/null http://localhost:$PORT/favicon.ico
popd

