#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# online file extension database https://fileinfo.com/extension/tga
# WINDEV tool useful on windows development machine
find-code.sh $* | egrep -i '\.(bmp|eps|gif|ico|jpe?g|miff|p[bgp]m|pcx|pdf|pn[gm]|tga|tiff?|x[pb]m|xcf|xwd)$'
