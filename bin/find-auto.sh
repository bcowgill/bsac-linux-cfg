#!/bin/bash
# find the auto-build timestamp and log files
# WINDEV tool useful on windows development machine

# use find-auto.sh -delete
# to delete the files found
find . \( -name 'auto-build*.log' -o -name pause-build.timestamp -o -name last-build.timestamp \) $*

