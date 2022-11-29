#!/bin/bash

DIR=${1:-$HOME}

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] directory

This will scan for music files supported by cmus and display them to make a playlist.

directory optional directory to scan. defaults to user's HOME environment setting.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

You should specify an absolute path as directory if you want cmus to be able to find the music files.

See also cmus, ls-sound.sh, find-sounds.sh, filter-sounds.sh

Example:

Add all playable files in user's home directory to the cmus playlist:

  $cmd \$HOME/Music | sort -n > ~/.cmus/playlist.pl

Other examples of playlists by directory or filtered with grep:

  $cmd \$HOME/d/Music/_NEW/douglas-adams | sort -n > ~/.cmus/h2g2.pl

  $cmd \$HOME/d/Music/peikoff-history-philosophy | sort -n > ~/.cmus/peikoff-history-philosophy.pl

  $cmd \$HOME | grep -i peikoff | sort -n > ~/.cmus/peikoff-all.pl
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

find $DIR \
	-type f \
	-regextype posix-egrep \
	-iregex '.+\.(aac|aif|aiff|ape|au|flac|m4a|mp3|mpc|ogg|wav|wma)$'
exit $?

#find $DIR \
	-type f \
	-iname '*.aac' \
	-o -iname '*.aif' \
	-o -iname '*.aiff' \
	-o -iname '*.ape' \
	-o -iname '*.au' \
	-o -iname '*.flac' \
	-o -iname '*.m4a' \
	-o -iname '*.mp3' \
	-o -iname '*.mpc' \
	-o -iname '*.ogg' \
	-o -iname '*.wav' \
	-o -iname '*.wma' \
