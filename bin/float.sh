#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# screen session to use in the i3 floating scratch pad window.
screen -D -R -U -S float -h 4096 -t bash script ~/float.log --append --command $SHELL
