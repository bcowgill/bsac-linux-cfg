#!/bin/bash
# auto rebuild when things change
TOUCH=last-build.timestamp
WAIT=6
TIMES=50
LOOPS=0

if [ -z "$1" ]; then
   echo You must supply a build command to run.
   exit 1
fi

while  [ /bin/true ]
do
   BUILDIT=0
   if [ -f $TOUCH ]; then
      if [ `find .. -newer last-build.timestamp | wc -l` == 0 ] ; then
         if [ $LOOPS -gt $TIMES ]; then
            echo `date --rfc-3339=seconds` still nothing new...
            LOOPS=0
         fi
      else
         BUILDIT=1
      fi
   else
      BUILDIT=1
   fi

   if [ $BUILDIT == 1 ]; then
      echo `date --rfc-3339=seconds` building because of something new
      $BUILD
      touch $TOUCH
   fi
   sleep $WAIT
   LOOPS=$(( $LOOPS + 1 ))
done
