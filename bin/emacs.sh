#!/bin/bash
# launch emacs in projects dir
pushd $HOME/projects
# add --debug-init for stack trace of .emacs loading
emacs --chdir $HOME/projects --title=emacs-projects \
	$* \
	&
#	-f shell \
#emacs --chdir $HOME/projects --title=emacs-projects \
#	-f shell \
#	$HOME/.emacs \
#	$HOME/bin/emacs.sh \
#	$HOME/bin/template/javascript/backbone.js \
#	$HOME/bin/template/cfgrec/emacs-keyref.txt \
#	$HOME/workspace/notes.txt \
#	$* \
#	-f delete-other-windows \
#	&
popd
