#!/bin/bash
# poor man's runit - keeps re-running a command when it dies.

if [ -z "$1" ]; then
   RUN='npm start'
else
   RUN="$*"
fi

while  [ /bin/true ]
do
   echo Press ^C to stop keeping it up [ $RUN ]
   sleep 2
   $RUN
   echo Exit $? from [ $RUN ]
done
