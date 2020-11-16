#!/bin/bash
# online file extension database https://fileinfo.com/extension/svg
# WINDEV tool useful on windows development machine
find-code.sh $* | egrep -i '\.(dia|svg|vsd)$'
