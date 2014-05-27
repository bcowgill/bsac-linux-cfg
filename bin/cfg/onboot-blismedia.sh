#!/bin/bash

# Start up a local webserver for the play/d3 area
pushd ~/workspace/play/
webserver.sh 9999 &
popd

pushd ~/workspace/play/open-layers/dist
webserver.sh 9191 &
popd

echo You need to start Charles before the browsers!

