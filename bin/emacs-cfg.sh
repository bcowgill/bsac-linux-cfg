#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# compare current emacs config with version under git control

DIFF=diff.sh
DIRECTION="$1"

$DIFF ~/.emacs ~/bin/cfg/.emacs $DIRECTION
$DIFF ~/.emacs-places ~/bin/cfg/.emacs-places $DIRECTION
$DIFF ~/.emacs.d/lisp/update.sh ~/bin/cfg/.emacs.d/lisp/update.sh $DIRECTION
$DIFF ~/.emacs.d/lisp/bsac.el ~/bin/cfg/.emacs.d/lisp/bsac.el $DIRECTION
$DIFF ~/.emacs.d/ ~/bin/cfg/.emacs.d/ $DIRECTION

