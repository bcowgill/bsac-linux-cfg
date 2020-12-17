#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# Use python to fire up a simple web server to serve content
# recognize the node npm config.port value if present and use that.

# WINDEV tool useful on windows development machine

PORT=$1
DOCROOT=$2
HTTP_MOD=SimpleHTTPServer

PYVER=`python --version 2>&1 | perl -pne 's{Python \s+(\d+).+}{$1\n}xmsg'`
if [ ${PYVER:-0} -gt 2 ]; then
	# for python 3.0+
	HTTP_MOD=http.server
fi

if [ "x$PORT" == "xslay" ]; then
	PORT=
	DOCROOT=slay
fi

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

if [ $DOCROOT == slay ]; then
	echo will slay webserver on port $PORT
	if which sw_vers > /dev/null 2>&1 ; then
		# MACOS!
		echo `ps -ef | grep $HTTP_MOD | grep -v grep | egrep "\\b$PORT\\b"`
		PID=`ps -ef | grep $HTTP_MOD | grep -v grep | egrep "\\b$PORT\\b" | perl -pne 's{\A \s+ \d+ \s+ (\d+) .+ \z}{$1}xmsg'`
	else
		echo `ps -ef | grep $HTTP_MOD | grep -v grep | egrep "\\b$PORT\\b"`
		PID=`ps -ef | grep $HTTP_MOD | grep -v grep | egrep "\\b$PORT\\b" | perl -pne 's{\A \s* \w+ \s+ (\d+) .+ \z}{$1}xmsg'`
	fi
	echo PID=$PID
	if [ ! -z "$PID" ]; then
		slay.sh $PID
	fi
	exit 0
fi

[ ! -d /tmp/$USER ] && mkdir -p /tmp/$USER
LOG=/tmp/$USER/webserver-$PORT.log
pushd $DOCROOT
[ -f $LOG ] && rm $LOG
(echo Serving content from `pwd`; echo on url-port http://localhost:$PORT; echo logging to $LOG) | tee $LOG
python -m $HTTP_MOD $PORT >> $LOG 2>&1 &
sleep 2
pswide.sh | grep python | grep $HTTP_MOD
if which wget 2> /dev/null; then
	wget --output-document=/dev/null http://localhost:$PORT/favicon.ico
else
	curl > /dev/null http://localhost:$PORT/favicon.ico
fi
popd
ps -ef | grep -i $HTTP_MOD
