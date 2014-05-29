#!/bin/bash

# Start up a local webserver for the play/d3 area
pushd ~/workspace/play/
webserver.sh 9999 &
popd

pushd ~/workspace/play/open-layers/dist
webserver.sh 9191 &
popd

# Start up infinity plus dashboard dev instance
pushd ~/workspace/projects/infinity-plus-dashboard/setup
./start-app.sh
popd

echo You need to start Charles before the browsers!

