#!/bin/bash
# grep through code for some stuff
egrep -rli "$1" . | egrep -v '/\.svn/|\.git/|/docs/|/test/(base|out)/\.(pdf|class)$'
