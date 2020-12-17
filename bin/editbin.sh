#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# launch emacs in ~/bin dir
pushd ~/bin
EMACS_FILES=`ls -1 template/cfgrec/emacs-*.txt`
emacs --chdir $HOME/bin --title=emacs-projects \
	-f shell \
	$HOME/.emacs \
	editbin.sh \
	$EMACS_FILES \
	template/cfgrec/notes.txt \
	./ \
	$* \
	-f delete-other-windows \
	&
popd

