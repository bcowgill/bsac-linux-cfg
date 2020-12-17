#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# configure git difftool and mergetool to use kdiff3
# https://stackoverflow.com/questions/33308482/git-how-configure-kdiff3-as-merge-tool-and-diff-tool

# change trustExitCode false  if it turns out kdiff3 does not exit with error codes properly.
# WINDEV tool useful on windows development machine

git config --global --add merge.tool kdiff3
git config --global --add mergetool.kdiff3.path "C:/Program Files/KDiff3/kdiff3.exe"
git config --global --add mergetool.kdiff3.trustExitCode true

git config --global --add diff.guitool kdiff3
git config --global --add difftool.kdiff3.path "C:/Program Files/KDiff3/kdiff3.exe"
git config --global --add difftool.kdiff3.trustExitCode true
