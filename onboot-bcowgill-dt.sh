#!/bin/bash

# Start up a local webserver for the play/d3 area
pushd ~/workspace/play/d3
webserver.sh 9999 &
popd
pushd ~/workspace/play/d3/WebContent/dataflow
webserver.sh 9898 &
popd
pushd ~/workspace/play/d3/WebContent/grunt-test/grunt-test-jshint-uglify
webserver.sh 8555 &
popd
echo You need to start Charles before the browsers!

