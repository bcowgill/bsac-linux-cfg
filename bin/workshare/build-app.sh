#!/bin/bash
# build and serve the app.
# this script is a helper for when the i3 window manager is starting
# up all the windows that are needed.

# TODO maybe start a screen/tmux session for two builds ??

# wait a bit for build-test.sh to do its job
sleep 5

grunt build
echo SHLVL=$SHLVL
echo waiting to begin serving the app...
read wait
grunt serve
echo SHLVL=$SHLVL
echo 'grunt build; grunt serve'

# TODO skip $SHELL if in a deep shell already
$SHELL
