#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# launch emacs in ergonomic mode
pushd ~/bin
HOME=~/myemacs/ergo emacs --title=emacs-ergonomic \
	$* \
	&
popd
