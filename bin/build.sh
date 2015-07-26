#!/bin/bash
# TODO maybe start a screen/tmux session for two builds ??
grunt build
echo waiting to begin serving tests
read wait
grunt serve:test
echo SHLVL=$SHLVL
echo grunt build; grunt serve:test
$SHELL
