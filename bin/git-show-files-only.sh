#!/bin/bash
# Show a git commit listing only the files involved
# alias gsfo=git-show-files-only.sh
git show $* --name-only --pretty=reference | grep -vE '\(.+\)'

