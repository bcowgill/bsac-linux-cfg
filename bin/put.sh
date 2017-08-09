#!/bin/bash
# put a relative file somewhere else creating directory structure
# assumes the environment variable TO specifies the destination directcory
# if no second parameter is given
# put.sh relative/path ... [target-path]

INDEX=music.txt

function usage
{
	local message
	exit=0
	message=$1
	if [ ! -z "$message" ]; then
		echo "$message"
		exit=1
	fi
	echo $0 source-path ... [target-path]
	echo " "
	echo put a directory or a file somewhere else but preserve the relative path structure.
	echo keeps a list of all the files in VOLUMENAME-$INDEX and stores one on the remote as $INDEX
	exit $exit
}

function put
{
	local src dest dir recurse to
	src="$1"
	dest="$2"
	if [ -z "$src" ]; then
		usage "You must provide a source-path."
	fi
	if [ -z "$dest" ]; then
		usage "You must provide a target-path or set the TO= environment variable."
	fi
	if [ -f "$dest" ]; then
		usage "You must provide a target-path, not a file, or set the TO= environment variable."
	fi

	dir=`dirname "$src"`
	to="$dest/$dir"
	mkdir -p "$to"
	if [ -d "$src" ]; then
		recurse=-r
		echo "put $src/ $to/ recursively"
	else
		recurse=
		echo "put $src $to/"
	fi
	cp $recurse "$src" "$to"
}

function summary
{
	local dest loc volume
	dest="$1"
	volume=`dirname "$dest"`
	loc=`dirname "$1"`
	loc=`basename "$loc"`-$INDEX

	echo generating $volume/$INDEX and saving a local copy to `pwd`/$loc
	pushd "$volume" >> /dev/null
	find music -type f | sort > $INDEX
	popd >> /dev/null
	cp "$volume/$INDEX" "$loc"
	df -k "$dest" | perl -pne 's{\A}{# }xmsg' | tee --append "$loc"
}

SRC="$1"
if [ -z "$TO" ]; then
	if [ ! -z "$3" ]; then
		usage "You cannot specify more than two files unless the target directory is defined in the TO= envirionment variable."
	else
		DEST="$2"
		put "$SRC" "$DEST"
	fi
else
	DEST="$TO"
	shift
	put "$SRC" "$DEST"
	while [ ! -z "$1" ]
	do
		SRC="$1"
		shift
		put "$SRC" "$DEST"
	done
fi

summary "$DEST"

