#!/bin/bash
# do a wide ps command on mac or linux
if which sw_vers > /dev/null; then
	# MACOS
	ps -ef -ww
else
	# linux below, mac above
	ps -ef --cols 256
fi
