#!/bin/bash
# setup / run a local bower repository cache
# STATUS: starts up, but doesn't seem to cache modules or fetch them successfully
# http://hacklone.github.io/private-bower/

PROXY=bower-proxy
PORT=8081
URL=http://$PROXY:$PORT/
NODE_VER=$HOME/.nvm/versions/node/v4.2.1
CACHE=$HOME/.bower-packages
CONFIG_DIR=$HOME/bin/workshare
CONFIG=$CONFIG_DIR/private-bower.json
LOG4JS_CONFIG=$CACHE/log4js.conf.json
BIN=$NODE_VER/bin
export PATH="$PATH:$BIN"

grep bower-proxy /etc/hosts
echo BIN=$BIN
echo CACHE=$CACHE
echo PATH=$PATH
echo URL=$URL

if [ ! -d $CACHE ]; then
	echo first time, set up what we need.
	mkdir -p $CACHE
	npm install -g private-bower
	cp $CONFIG $CACHE
	cp $CONFIG_DIR/private-bower-log4js.conf.json $CACHE/log4js.conf.json
	cp $CONFIG_DIR/bowerrc $HOME/.bowerrc
fi

cd $CACHE
ls
DEBUG=* forever $BIN/private-bower \
	--config=$CACHE/private-bower.json

