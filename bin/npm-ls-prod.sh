#!/bin/bash
# npm list all top level production packages
npm list --prod --depth=0 | tail -n +2 | perl -pne 's{\A[^\(a-z]+}{}xmsg'
