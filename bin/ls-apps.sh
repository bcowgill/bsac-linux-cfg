#!/bin/bash
# list apps running, less detail than what-apps.sh
pswide.sh | what-is-running.pl | grep ___ | egrep -v 'grep|cross-env'
