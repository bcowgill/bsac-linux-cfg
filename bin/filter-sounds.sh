#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine
GREP="egrep -i"

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--regex] [--help|--man|-?]

This will filter a list of file names looking for audio, sound, or music file extensions.

--regex Shows the regex used for matching sound file extensions.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.


See also find-audio find-sounds.sh, find-ez-sounds.sh, sound-play.sh, classify.sh

See the online file extension database https://fileinfo.com/extension/wav

Example:

locate -i elvis | $cmd
"
	exit $code
}
if [ "$1" == "--help" ]; then
	usage 0
fi
if [ "$1" == "--man" ]; then
	usage 0
fi
if [ "$1" == "-?" ]; then
	usage 0
fi

if [ "$1" == "--regex" ]; then
	GREP="echo"
fi

$GREP '\.(669|aac|aiff|am[fs]|ape|au|dmf|dsm|far|flac|it|m3u|m4[ap]|mdl|m[eo]d|midi?|mp[23]|mt[2m]|og[ag]|pls|p[st]m|s[3t]m|smp|snd|ult|umx|voc|wa?v|wma|xm)\b' # .wav .mp3 .ogg .mod
