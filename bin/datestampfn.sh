#!/bin/bash
# output an rfc-3339 timestamp suitable for a file name.
# 2017-11-07-12:32:52+00:00 becomes
# 2017-11-07-12h32m52s+00h00s
# WINDEV tool useful on windows development machine
date '+%Y-%m-%d-%H:%M:%S%z' | perl -pne 's{(\d\d \s*) \z}{:$1}xmsg' \
 | perl -pne 's{(\d+):(\d+):(\d+)([\+\-])(\d+):(\d+)}{$1h$2m$3s$4$5h$6m}xms'
