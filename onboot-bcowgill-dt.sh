#!/bin/bash

# Start up a local webserver for the play/d3 area
pushd ~/workspace/play/d3
webserver.sh 9999 > /tmp/bcowgill-webserver-9999.log 2>&1 &
popd
pushd ~/workspace/play/d3/WebContent/dataflow
webserver.sh 9898 > /tmp/bcowgill-webserver-9898.log 2>&1 &
popd
echo You need to start Charles before the browsers!

