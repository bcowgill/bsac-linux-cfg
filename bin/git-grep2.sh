#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# simple git grep for lines containing both expressions, highlighting the first one
# WINDEV tool useful on windows development machine
git grep "$1" | grep "$2" | grep --color "$1"
