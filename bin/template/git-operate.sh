#!/bin/bash
# operate on modified and added files from a git repo
# filenames with tricky characters will be a problem, -z format remedies that
echo Modified
git status --porcelain | perl -ne 's{\A \s M \s+}{}xms && print;'
echo Added
git status --porcelain | perl -ne 's{\A A \s+}{}xms && print;'
echo Renamed
git status --porcelain | perl -ne 's{\A R \s+ .+? \s+ -> \s+ }{}xms && print;'

