#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# Use python to fire up a simple web server to serve content
# recognize the node npm config.port value if present and use that.

# WINDEV tool useful on windows development machine

# requires slay.sh
# requires pswide.sh

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] --slay [port] [docroot]

This will use python to fire up a simple web server to serve content from a local directory.

port    optional. Specify a port number to use for the http server. Defaults to 9999 or the port number specified in \$npm_package_config_port from your package.json
docroot optional. Specify a directory name to serve web content documents from. Defaults to current directory.
--slay  Will terminate the webserver specified by the default port or the port privided.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

The webserver will log requests to /tmp/USER/webserver-PORT.log

See also slay.sh

Example:

$cmd 58008 public
"
	exit $code
}
if [ "$1" == "--help" ]; then
	usage 0
fi
if [ "$1" == "--man" ]; then
	usage 0
fi
if [ "$1" == "-?" ]; then
	usage 0
fi

PORT=$1
DOCROOT=$2
HTTP_MOD=SimpleHTTPServer

PYVER=`python --version 2>&1 | perl -pne 's{Python \s+(\d+).+}{$1\n}xmsg'`
if [ ${PYVER:-0} -gt 2 ]; then
	# for python 3.0+
	HTTP_MOD=http.server
fi

if [ "x$PORT" == "x--slay" ]; then
	PORT=$2
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
pushd $DOCROOT > /dev/null
[ -f $LOG ] && rm $LOG
(echo HTTP server: Serving content from `pwd`; echo on url-port http://localhost:$PORT; echo logging to $LOG) | tee $LOG
python -m $HTTP_MOD $PORT >> $LOG 2>&1 &
sleep 2
pswide.sh | grep python | grep $HTTP_MOD
if which wget 2> /dev/null; then
	wget --method HEAD --output-document=/dev/null http://localhost:$PORT/favicon.ico
	wget --method HEAD --output-document=/dev/null http://localhost:$PORT/index.html
else
	echo http://localhost:$PORT/favicon.ico
	curl --head http://localhost:$PORT/favicon.ico
	echo http://localhost:$PORT/index.html
	curl --head http://localhost:$PORT/index.html
fi
popd > /dev/null
ps -ef | grep -v grep | grep -i $HTTP_MOD
