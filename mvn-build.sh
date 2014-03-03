#!/bin/bash
# do build with failures terminating at end of build
pushd $HOME/workspace/ontoscope
touch before-build.timestamp
mvn install -fae 2>&1 | tee build.log
touch after-build.timestamp
popd
