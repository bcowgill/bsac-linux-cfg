#!/bin/bash
# grep through code for some stuff
egrep -rl "$1" . | egrep -v '/\.svn/|\.git/|/docs/|\.(pdf|class)$'
