#!/bin/bash
# npm update all top level production packages to latest version
npm install --save `npm-ls-prod.sh | perl -pne 's{(\@).+\n}{$1latest\n}xmsg;'` $*
