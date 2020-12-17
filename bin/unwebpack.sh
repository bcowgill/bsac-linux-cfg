#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# very simple unwebpack so that webpack's output can be diffed/searched a bit easier
# See unminify.sh for a more complete version if you have prettydiff.sh
# See also css-diagnose.sh debug-css.sh unminify.sh unwebpack.sh
# WINDEV tool useful on windows development machine
f="$1"
perl -pne 's{([,;])}{$1\n}xmsg' $f > $f.js.unwebpacked
