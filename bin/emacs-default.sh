#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# launch emacs in default mode
pushd ~/bin
HOME=~/myemacs/default emacs --title=emacs-default \
	$* \
	&
popd
