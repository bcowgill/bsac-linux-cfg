#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# undeletes files from git by doing a git checkout --
# WINDEV tool useful on windows development machine
git checkout -- `git status --short | grep '^ D' | perl -pne 's{ D }{}xms'`
