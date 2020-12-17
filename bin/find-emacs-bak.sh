#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# find all emacs related backup files in current directory

# use find-emacs-bak.sh -delete
# to delete the files found
find . \( -name '.#*' -o -name '#*#' \) $*
