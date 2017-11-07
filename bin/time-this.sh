#!/bin/bash
# time how long a command takes
START=$SECONDS
echo `datestamp.sh` Time this starting
echo command: $*
$*
echo `datestamp.sh` Time this finished
END=$SECONDS
ELAPSED=$(($END - $START))
echo ELAPSED=$ELAPSED

