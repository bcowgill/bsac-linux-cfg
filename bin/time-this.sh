#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# time how long a command takes
# WINDEV tool useful on windows development machine
START=$SECONDS
echo `datestamp.sh` Time this starting
echo command: $*
$*
echo `datestamp.sh` Time this finished
END=$SECONDS
ELAPSED=$(($END - $START))
echo ELAPSED=$ELAPSED

