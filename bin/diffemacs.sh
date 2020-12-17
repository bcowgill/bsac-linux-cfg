#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# diff the emacs config files vs git versions
diff.sh ~/.emacs ~/bin/cfg/.emacs $1
diff.sh ~/.emacs.d ~/bin/cfg/.emacs.d $1
