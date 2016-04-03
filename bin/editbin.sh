#!/bin/bash
# launch emacs in ~/bin dir
pushd ~/bin
EMACS_FILES=`ls -1 template/cfgrec/emacs-*.txt`
emacs --chdir $HOME/bin --title=emacs-projects \
	$HOME/.emacs \
	$EMACS_FILES \
	template/cfgrec/notes.txt \
    ./ \
	$* \
	-f delete-other-windows \
	&
popd

