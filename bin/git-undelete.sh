#!/bin/bash
# undeletes files from git by doing a git checkout --
git checkout -- `git status --short | grep '^ D' | perl -pne 's{ D }{}xms'`
