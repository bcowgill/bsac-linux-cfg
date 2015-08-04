#!/bin/bash
# build and serve the cirrus ruby back end
# this script is a helper for when the i3 window manager is starting
# up all the windows that are needed.

# TODO maybe start a screen/tmux session for two builds ??

source $HOME/.rvm/scripts/rvm
rvm use 2.1.5

echo SHLVL=$SHLVL
echo waiting to begin serving the cirrus ruby app...
read wait
bundle exec rails server
echo SHLVL=$SHLVL
echo 'bundle exec rails server'

# TODO skip $SHELL if in a deep shell already
$SHELL

