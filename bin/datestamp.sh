# output an rfc-3339 timestamp.
# 2017-11-07 12:32:52+00:00
if date --rfc-3339=seconds 2> /dev/null; then
	exit 0
else
#	date '+%Y-%m-%d %H:%M:%S%:z' on linux it would be
	date '+%Y-%m-%d %H:%M:%S%z' | perl -pne 's{(\d\d \s*) \z}{:$1}xmsg'
fi
