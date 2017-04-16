#!/bin/bash
# start up an upper screen session with build running.

# -U utf8 -L logs output -h size of scrollback history buffer
screen -S build-upper -U -h 8192 -c ~/bin/screenrc.build.upper
