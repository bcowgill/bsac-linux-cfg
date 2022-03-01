#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# start up git gui in your current project directory

# WINDEV tool useful on windows development machine
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
if [ "$HOSTNAME" == "C02TN1QRG8WL" ]; then
	# configure allianz project directory
	cd ~/workspace/projects/allianz/personal-assistant-app
fi
git gui&
