#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# send files to a running emacs instance or start up a new one if the server is not running
# strip any trailing :\d+ from a single file name in case you pasted from a grep listing

LAUNCH="emacsclient --no-wait --alternate-editor=emacs"

if [ -z "$2" ]; then
	FILE=`echo $1 | perl -pne 's{:[:a-z0-9]* \s* \z}{}xmsgi'`
	#echo edit [$FILE]
	$LAUNCH "$FILE"
else
	$LAUNCH $*
fi
