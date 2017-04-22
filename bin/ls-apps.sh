#!/bin/bash
# list apps running, less detail than what-apps.sh
ps -ef --cols 256 | what-is-running.pl | grep ___ | egrep -v 'grep|cross-env'
