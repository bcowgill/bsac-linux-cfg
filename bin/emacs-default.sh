#!/bin/bash
# launch emacs in default mode
pushd ~/bin
HOME=~/myemacs/default emacs --title=emacs-default \
	$* \
	&
popd
