#!/bin/bash
# find all emacs related backup files in current directory

# use find-emacs-bak.sh -delete
# to delete the files found
find . \( -name '.#*' -o -name '#*#' \) $*
