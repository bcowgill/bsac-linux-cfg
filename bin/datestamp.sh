# output an rfc-3339 ish timestamp. exact on linux, almost on Mac.
# 2017-11-07 12:32:52-00:00 -- linux output
# 2017-11-07 12:32:52+0000  -- mac output
if date --rfc-3339=seconds 2> /dev/null; then
	exit 0
else
	date '+%Y-%m-%d %H:%M:%S%z'
fi
