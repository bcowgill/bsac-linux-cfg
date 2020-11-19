#!/bin/bash
# annotate a commit with a tag
# example tag the previous commit
# git-tag.sh my-tag-name "description of tag" HEAD^
# WINDEV tool useful on windows development machine

TAG="$1"
NOTE="$2"
COMMIT="${3:-HEAD}"
git tag -a "$TAG" -m "$NOTE" $COMMIT
git show "$TAG"
git tag
# need to  push the tags manually
echo git push origin "$TAG"
echo or all tags
echo git push --tags

