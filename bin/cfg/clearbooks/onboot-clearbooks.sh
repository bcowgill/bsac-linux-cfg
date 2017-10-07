#!/bin/bash

# only run some things as needed
DOIT=false
#DOIT=true

# always run these
RUNIT=true

TEST_DIR=$HOME/workspace/projects/TODO/test

if $RUNIT; then

echo === Start up a local webserver for the play/ area
pushd ~/workspace/play/
   webserver.sh 9999 &
popd

fi # $RUNIT
