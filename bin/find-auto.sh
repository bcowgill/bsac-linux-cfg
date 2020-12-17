#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# find the auto-build timestamp and log files
# See also auto-build.sh, fix-javascript.sh, git-mv-src.sh, git-rebase.sh, srep.sh
# WINDEV tool useful on windows development machine

# use find-auto.sh -delete
# to delete the files found
find . \( -name 'auto-build*.log' -o -name pause-build.timestamp -o -name last-build.timestamp \) $*

