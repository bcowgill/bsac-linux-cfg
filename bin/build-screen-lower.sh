#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# start up a lower screen session with build running.
#echo usual BUILD LOWER COMPANY=$COMPANY PATH=$PATH >> /tmp/BUILD.log

# -U utf8 -L logs output -h size of scrollback history buffer
screen -D -R -S build-lower -U -h 8192 -c ~/bin/$COMPANY/screenrc.build.lower
