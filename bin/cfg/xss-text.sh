#!/bin/bash
# use text based screen savers only
pushd ~
	rm .xscreensaver
	ln -s  bin/cfg/.xscreensaver-textbased .xscreensaver
	ls -al .xsc*
popd
