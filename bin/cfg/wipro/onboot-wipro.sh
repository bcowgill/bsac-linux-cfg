#!/bin/bash

# only run some things as needed
DOIT=/usr/bin/false
#DOIT=/usr/bin/true

# always run these
RUNIT=/usr/bin/true

TEST_DIR=$HOME/workspace/projects/TODO/test

if $RUNIT; then

echo === Start up a local webserver for the play/ area
pushd ~/workspace/play/
   webserver.sh 9999 &
popd

fi # $RUNIT
