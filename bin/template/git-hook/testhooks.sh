#!/bin/bash
# installs the git logging hooks followed by the hooks here
rm ~/githooks.log
touch ~/githooks.log
pushd ../../cfg/log-githook/
	./install.sh
popd
./install.sh prepare-commit-msg.logged prepare-commit-msg

