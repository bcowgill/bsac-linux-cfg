#!/bin/bash
# kill first python app, assuming it is the web server
pswide.sh | grep python
kill -9 `ps -s | grep python | head -1 | perl -pne '@x = split(/\s+/); $_ = $x[1]'`

