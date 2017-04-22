#!/bin/bash
# list apps running, less detail than what-apps.sh
ps -ef | what-is-running.pl | grep ___ | egrep -v 'grep|cross-env'
