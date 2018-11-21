#!/bin/bash
# do a wide ps command on mac or linux
if which sw_vers > /dev/null 2>&1 ; then
	# MACOS
	ps -ef -ww
else
	if [ "$OSTYPE" == "msys" ]; then
		# windows
		ps -ef
	else
		# linux below
		ps -ef --cols 256
	fi
fi
