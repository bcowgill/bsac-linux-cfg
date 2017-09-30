#!/bin/bash
# find the auto-build timestamp and log files

# use find-auto.sh -delete
# to delete the files found
find . \( -name 'auto-build*.log' -o -name last-build.timestamp \) $*

