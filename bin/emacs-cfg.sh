#!/bin/bash
# compare current emacs config with version under git control

DIFF=vdiff.sh
if [ "${1:-normal}" == "reverse" ]; then
	DIFF=rvdiff.sh
fi

$DIFF ~/.emacs ~/bin/cfg/.emacs
$DIFF ~/.emacs-places ~/bin/cfg/.emacs-places
$DIFF ~/.emacs.d/lisp/update.sh ~/bin/cfg/.emacs.d/lisp/update.sh
$DIFF ~/.emacs.d/lisp/bsac.el ~/bin/cfg/.emacs.d/lisp/bsac.el
$DIFF ~/.emacs.d/ ~/bin/cfg/.emacs.d/

