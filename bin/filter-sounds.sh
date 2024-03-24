#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine
GREP="egrep -i"

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--regex] [--help|--man|-?] [-v] [path...]

This will filter a list of file names or grep output looking for audio, sound, or music file extensions.

path    File names to process. If omitted then standard input will be scanned.
-v      Filter out the sound files and show all other files.
--regex Shows the regex used for matching sound file extensions.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

In addition to -v, other egrep command options can be supplied.

See also egrep filter-mime-audio.pl find-audio find-sounds.sh, find-ez-sounds.sh, sound-play.sh, classify.sh

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
	shift
	GREP="echo"
fi

$GREP '\.(669|ac3|aac|aiff|am[fs]|ape|au|dmf|dsm|far|flac|it|m3u|m4[ap]|mdl|m[eo]d|midi?|mp[23]|mt[2m]|og[ag]|pls|p[st]m|s[3t]m|smp|snd|ult|umx|voc|wa?v|wma|xm)(:|"|\s*$)' $* # .669 .ac3 .aac .aif .amf .ams .ape .au .dmf .dsm .far .flac .it .m3u .m4a .m4p .mdl .med .mod .mid .midi .mp2 .mp3 .mt2 .mtm .oga .ogg .pls .psm .ptm .s3m .s3t .smp .snd .ult .umx .voc .wa .wav .wma .xm
