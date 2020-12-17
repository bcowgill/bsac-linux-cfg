#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# show git log messages with relative age
# WINDEV tool useful on windows development machine
git log --format="format:%h %cr %cn %s" $*
