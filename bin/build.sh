#!/bin/bash
pushd ~/projects/dealroom-ui
# start a screen/tmux session for two builds
grunt build
sleep 5
grunt serve:test
