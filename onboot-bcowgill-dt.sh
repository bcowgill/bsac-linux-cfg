#!/bin/bash

# Start up a local webserver for the play/d3 area
pushd ~/workspace/play/d3
webserver.sh 9999 > /tmp/bcowgill-webserver.log 2>&1 &
popd
