#!/bin/bash

FIELDS="${FIELDS:-TPE1|TALB|TIT2|COMM|TCON|TYER|TRCK}"

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "$cmd [--help|--man|-?] filename...

Get the id3v2 metadata from a song file and list it as arguments to the id3v2 command itself.

FIELDS  Environment var specifying which id3v2 tag names to use.  default is $FIELDS
VALUES  Environment var if set will only output the meta values without the filename. If set to 2 will only output the value, not the property name.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

The FIELDS environment value is a pipe '|' separatee list of id3v2 field names supported.

See also id3v2 id3info ls-meta.sh ls-music.sh id3v2-track.sh filter-id3.pl label-music.sh label-podcast.sh rename-podcast.sh

Example:

	Get just the track number and content (genre) number from the file specified.

FIELDS='TRCK|TCON' $cmd filename.mp3
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
if echo "$*" | grep -- '--' > /dev/null; then
	echo "unknown parameter provided, please study the command usage below."
   echo ""
	usage 1
fi

function get_song_track {
	local file
	file="$1"
	id3v2 --list-rfc822 "$file" \
		| grep -E "$FIELDS" \
		| sort -r \
		| VALUES=$VALUES perl -pne '
			%Map=qw(TPE1 artist TALB album TIT2 song COMM comment TCON genre TYER year TRCK track);
			if ($ENV{VALUES} eq "2")
			{
				s{\A\w+:\s}{"}xms;
			}
			else
			{
				s{\A(\w+)}{"--" . $Map{$1}}xmse;
				s{:\s+}{="}xms;
			}
			s{\n}{" }xms;
			s{(genre=).+?(\d+)\)}{$1=$2}xms;
			s{(comment=) "\(([^)]*)\) \[([^\]]*)\] : \s (.*)"}{$1"$2:$4:$3"}xms;
		'
}

for file in $*;
do
	ARGS=`get_song_track "$file"`
	if [ -z "$VALUES" ]; then
		echo id3v2 $ARGS "$file"
	else
		echo $ARGS
	fi
done

exit 0
id3v2 --list-rfc822
Filename: 01-Original-Broadway-Cast-Recording-Overture-Work-Song.mp3
APIC: ()[, 0]: image/jpg, 8934 bytes
UFID: http://www.cddb.com/id3/taginfo1.html, 53 bytes
PRIV:  (unimplemented)
PRIV:  (unimplemented)
PRIV:  (unimplemented)
PRIV:  (unimplemented)
PRIV:  (unimplemented)
PRIV:  (unimplemented)
PRIV:  (unimplemented)
TLEN: 306703
TPE1: Les Miserables Cast Recording
TALB: Les Miserables (1 of 2)
TPE2: Les Miserables Cast Recording
TIT2: Overture/Work Song
TCOM: Schönberg, Claude-Michel
TPUB: First Night/Relativity
TRCK: 1
TYER: 1985
TDRC:  frame
RGAD:  frame
TXXX: (replaygain_track_gain): 2.90 dB
TXXX: (replaygain_track_peak): 0.545220
TXXX: (replaygain_album_gain): 0.43 dB
TCON: Musical (77)
01-Original-Broadway-Cast-Recording-Overture-Work-Song.mp3: No ID3v1 tag
