#!/bin/bash
# start up a lower screen session with build running.

# -U utf8 -L logs output -h size of scrollback history buffer
screen -S build-lower -U -h 8192 -c ~/bin/screenrc.build.lower
