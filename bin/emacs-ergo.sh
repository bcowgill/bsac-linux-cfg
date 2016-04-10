#!/bin/bash
# launch emacs in ergonomic mode
pushd ~/bin
HOME=~/myemacs/ergo emacs --title=emacs-ergonomic \
	$* \
	&
popd
