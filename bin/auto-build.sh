#!/bin/bash
# auto rebuild when things change
TOUCH=last-build.timestamp
WATCHDIR=..
WAIT=6
TIMES=50
LOOPS=0
IGNORE='\.swp|\.kate-swp|/\.git/'

if [ -z "$1" ]; then
   echo You must supply a build command to run.
   exit 1
fi
if [ -z "$2" ]; then
   echo Will watch for file changes in dir $WATCHDIR.
   exit 1
fi
BUILD="$1"
echo BUILD=$BUILD
echo TOUCH=$TOUCH
echo IGNORE="$IGNORE"

while  [ /bin/true ]
do
   BUILDIT=0
   if [ -f $TOUCH ]; then
      if [ `find "$WATCHDIR" -newer $TOUCH -type f | egrep -v "$IGNORE" | wc -l` == 0 ]; then
         if [ $LOOPS -gt $TIMES ]; then
            echo `date --rfc-3339=seconds` still nothing new...
            LOOPS=0
         fi
      else
         echo `date --rfc-3339=seconds` "building ($BUILD) because of something new"
         find "$WATCHDIR" -newer $TOUCH -type f | egrep -v "$IGNORE" | head
         BUILDIT=1
      fi
   else
      echo `date --rfc-3339=seconds` "building ($BUILD) because of no $TOUCH file"
      BUILDIT=1
   fi
   if [ $BUILDIT == 1 ]; then
      $BUILD
      touch $TOUCH
      LOOPS=0
   fi
   sleep $WAIT
   LOOPS=$(( $LOOPS + 1 ))
done
