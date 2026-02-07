#!/bin/sh
find . -daystart -not -mtime +$*
# find files that have been modified recently, within some number of days.
# you can add additional find parameters to the command line:
# find-recent.sh 3 # list file and dir names changed in the last 3 days
# find-recent.sh 30 -type f -ls  # full listing for files only changed in last 30 days
