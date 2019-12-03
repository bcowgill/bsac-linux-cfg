#!/bin/bash
# npm list all top level development packages
npm list --dev --depth=0 | tail -n +2 | perl -pne 's{\A[^\(a-z]+}{}xmsg'
