#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# Launch IntelliJ editor
DIR=/tmp/$USER
LOG=$DIR/idea.log

mkdir -p $DIR 2> /dev/null
rm $LOG 2> /dev/null
~/bin/idea/bin/idea.sh >> $LOG 2>&1 &
