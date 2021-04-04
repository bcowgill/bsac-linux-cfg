#!/bin/bash
# start up git gui in your current project directory

# CUSTOM settings you may need to change on a new machine
cd ~/bin
if [ "$HOSTNAME" == "worksharexps-XPS-15-9530" ]; then
	#cd ~/projects/files-ui
	cd ~/projects/docuzilla
fi
if [ "$HOSTNAME" == "brent-Aspire-VN7-591G" ]; then
	# configure clearbooks project directory
	cd ~/projects/clearbooks-micro-api-auth
fi
git gui&
