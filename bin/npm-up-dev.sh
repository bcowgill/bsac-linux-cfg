#!/bin/bash
# npm update all top level development packages to latest version
npm install --save-dev `npm-ls-dev.sh | perl -pne 's{(\@).+\n}{$1latest\n}xmsg;'` $*
