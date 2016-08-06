#!/bin/bash
# start up git gui in your current project directory

if [ "$HOSTNAME" == "worksharexps-XPS-15-9530" ]; then
	#cd ~/projects/files-ui
	cd ~/projects/docuzilla
fi
if [ "$HOSTNAME" == "akston" ]; then
	cd ~/bin
fi
git gui&
