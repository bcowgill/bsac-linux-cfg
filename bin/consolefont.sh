#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# change to system console font with a text mode gui
setfont /usr/share/consolefonts/Lat7-Terminus32x16.psf.gz
dpkg-reconfigure --priority=low console-setup
