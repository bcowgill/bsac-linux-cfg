#!/bin/bash
# list apps running
ps -ef | what-is-running.pl | grep ___ | egrep -v 'grep|cross-env'
