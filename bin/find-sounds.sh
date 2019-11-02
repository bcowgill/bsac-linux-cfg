#!/bin/bash
# online file extension database https://fileinfo.com/extension/wav
find-code.sh $* | egrep -i '\.(669|aac|aiff|am[fs]|ape|au|dmf|dsm|far|flac|it|m3u|m4[ap]|mdl|m[eo]d|midi?|mp[23]|mt[2m]|og[ag]|pls|p[st]m|s[3t]m|smp|snd|ult|umx|voc|wa?v|wma|xm)$' # wav mp3 ogg mod
