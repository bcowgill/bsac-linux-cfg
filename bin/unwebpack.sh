#!/bin/bash
# very simple unwebpack so that webpack's output can be diffed/searched a bit easier
f="$1"
perl -pne 's{([,;])}{$1\n}xmsg' $f > $f.js.unwebpacked
