#!/bin/bash
# build and serve the browser tests.
# this script is a helper for when the i3 window manager is starting
# up all the windows that are needed.

# TODO maybe start a screen/tmux session for two builds ??
grunt build
echo SHLVL=$SHLVL
echo waiting to begin serving tests...
read wait
grunt serve:test
echo SHLVL=$SHLVL
echo 'grunt build; grunt serve:test'
# TODO skip $SHELL if in a deep shell already
$SHELL
