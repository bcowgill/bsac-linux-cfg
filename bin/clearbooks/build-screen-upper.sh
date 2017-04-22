#!/bin/bash
# start up an upper screen session with build running.

#echo clearbooks BUILD UPPER COMPANY=$COMPANY PATH=$PATH >> /tmp/BUILD.log
# -U utf8 -L logs output -h size of scrollback history buffer
screen -D -R -S build-upper -U -h 8192 -c ~/bin/$COMPANY/screenrc.build.upper
