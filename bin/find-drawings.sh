#!/bin/bash
# online file extension database https://fileinfo.com/extension/svg
find-code.sh $* | egrep -i '\.(dia|svg|vsd)$'
