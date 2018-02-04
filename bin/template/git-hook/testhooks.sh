#!/bin/bash
# installs the git logging hooks followed by the hooks here
rm ~/githook.log
touch ~/githook.log
pushd ../../cfg/log-githook/
	./install.sh
popd
./install.sh prepare-commit-msg.logged prepare-commit-msg
./install.sh commit-msg.logged commit-msg

