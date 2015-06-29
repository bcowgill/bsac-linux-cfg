#!/bin/bash

# only run some things as needed
DOIT=/bin/false
#DOIT=/bin/true

# always run these
RUNIT=/bin/true

TEST_DIR=$HOME/workspace/projects/infinity-plus-dashboard/test

if $RUNIT; then

echo === Start up a local webserver for the play/ area
pushd ~/workspace/play/
   webserver.sh 9999 &
popd

fi # $RUNIT
