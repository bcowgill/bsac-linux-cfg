#!/bin/bash
# launch the mongodb graphical database admin tool
DIR=/tmp/$USER
LOG=$DIR/robo3t.log
~/bin/robo3t/bin/robo3t >> $LOG 2>&1 &

