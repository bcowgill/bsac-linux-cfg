#!/bin/bash
. ~/.nvm/nvm.sh

ZONE=Europe/London
O=linux
ZSL=zone-map-short-long-$O.txt

nvm use v8.11.1
echo -n "$ZONE: " >> $ZSL
echo -n `TZ=$ZONE node -p 'now = new Date("Sun Jan 1 01:02:03 GMT 2023"); now.toString().replace(/^.*(\(.*\)).*$/, "$1")'` >> $ZSL
nvm use v17.9.1
TZ=$ZONE node -p 'now = new Date("Sun Jan 1 01:02:03 GMT 2023"); now.toString().replace(/^.*(\(.*\)).*$/, "$1")' >> $ZSL

nvm use v8.11.1
echo -n "+$ZONE: " >> $ZSL
echo -n `TZ=$ZONE node -p 'now = new Date("Sat Jul 1 01:02:03 GMT 2023"); now.toString().replace(/^.*(\(.*\)).*$/, "$1")'` >> $ZSL
nvm use v17.9.1
TZ=$ZONE node -p 'now = new Date("Sat Jul 1 01:02:03 GMT 2023"); now.toString().replace(/^.*(\(.*\)).*$/, "$1")' >> $ZSL
