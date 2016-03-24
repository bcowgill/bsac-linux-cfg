#!/bin/bash
# start npm proxy to locally save npm modules for less downloading
# http://willcodefor.beer/setup-your-own-npm-cache-server/

YEAR_IN_SECS=31536000
KEEP=$YEAR_IN_SECS
PROXY=npm-proxy
PORT=8080
URL=http://$PROXY:$PORT/
NODE_VER=$HOME/.nvm/versions/node/v4.2.1
CACHE=$NODE_VER/lib/node_modules/npm-proxy-cache/cache
BIN=$NODE_VER/bin
export PATH="$PATH:$BIN"

#CACHE=$HOME/.npm-packages
#BIN=$CACHE/bin
#BIN=`nvm which | grep -v Found`/..

grep npm-proxy /etc/hosts
echo BIN=$BIN
echo CACHE=$CACHE
echo PATH=$PATH

npm config delete prefix $CACHE

if [ ! -d $CACHE ]; then
	echo first time, set up what we need.
	npm config delete proxy
	npm config delete https-proxy
	npm config delete strict-ssl
	npm install -g forever npm-proxy-cache
	ln -s $CACHE $HOME/.npm-packages
fi

npm config set proxy $URL
npm config set https-proxy $URL
npm config set strict-ssl false

forever $BIN/npm-proxy-cache \
	--expired --ttl $KEEP \
	--friendly-names \
	--host npm-proxy --port=$PORT
#	--verbose \

