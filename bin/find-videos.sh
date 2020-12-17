#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# online file extension database https://fileinfo.com/extension/srt
# WINDEV tool useful on windows development machine
find-code.sh $* | egrep -i '\.(abc|as[fx]|avi|divx|fl[iv]|fxm|m2ts?|m4v|mkv|mng|mo[dv]|mp4|mp(e|g|eg)|og[mvx]|srt|swf|t[ps]|vcd|vdr|viv|vob|wmv|yuv)$' # mod
