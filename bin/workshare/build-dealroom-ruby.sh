#!/bin/bash
# build and serve the ruby back end
# this script is a helper for when the i3 window manager is starting
# up all the windows that are needed.

# TODO maybe start a screen/tmux session for two builds ??

source $HOME/.rvm/scripts/rvm
redis-server &

echo SHLVL=$SHLVL
echo waiting to begin serving the dealroom ruby app...
read wait
RAILS_RELATIVE_URL_ROOT='/dealroom' bundle exec rails server -p 3001
echo SHLVL=$SHLVL
echo 'bundle exec rails server -p 3001'

# TODO skip $SHELL if in a deep shell already
$SHELL
