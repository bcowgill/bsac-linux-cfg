# output an rfc-3339 timestamp suitable for a file name.
# 2017-11-07-12:32:52+00:00
date '+%Y-%m-%d-%H:%M:%S%z' | perl -pne 's{(\d\d \s*) \z}{:$1}xmsg'
