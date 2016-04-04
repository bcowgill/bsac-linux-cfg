#!/bin/bash
# launch emacs in projects dir
pushd $HOME/projects
emacs --chdir $HOME/projects --title=emacs-projects \
	-f shell \
	$HOME/.emacs \
	$HOME/bin/emacs.sh \
	$HOME/bin/template/javascript/backbone.sh \
	$HOME/workspace/notes.txt \
	./ \
	$* \
	-f delete-other-windows \
	&
popd
