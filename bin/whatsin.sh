#!/bin/bash
# Show what kind of files are in a directory
# See also ls-types.sh, ls-types.pl
# WINDEV tool useful on windows development machine
find $* -type f -exec file {} \;
