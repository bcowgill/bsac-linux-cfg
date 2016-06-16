#!/bin/bash
# send files to a running emacs instance or start up a new one if the server is not running
# strip any trailing : from a single file name in case you pasted from a grep listing

LAUNCH="emacsclient --no-wait --alternate-editor=emacs"

if [ -z "$2" ]; then
	DIR=`dirname $1`
	FILE=`basename $1 :`
	#echo edit [$DIR] [$FILE]
	$LAUNCH "$DIR/$FILE"
else
	$LAUNCH $*
fi
