#!/bin/bash
# screen session to use in the i3 floating scratch pad window.
screen -U -S float -h 4096 -t bash script ~/float.log --append --command $SHELL
