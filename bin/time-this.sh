#!/bin/bash
# time how long a command takes
START=$SECONDS
echo `date --rfc-3339=seconds` Time this starting
echo command: $*
$*
echo `date --rfc-3339=seconds` Time this finished
END=$SECONDS
ELAPSED=$(($END - $START))
echo ELAPSED=$ELAPSED

