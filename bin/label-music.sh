#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# Add meta data to a song / music file that has little to none aleady.

FILE="$1"

function usage {
	echo "
$0 filename

	You must provide a file name of a song, music file or podcast to label.
"

	exit 1
}

if [ -z "$FILE" ]; then
	usage
fi
if [ "$FILE" == "--help" ]; then
	usage
fi
if [ "$FILE" == "--man" ]; then
	usage
fi
if [ "$FILE" == "-?" ]; then
	usage
fi


function update_v2_field {
	local switch2 help CHOOSE
	switch2="$1"
	help="$2"
	echo ----------
	id3v2 --list-rfc822 "$FILE" | grep $switch2:
	# or help for more help info about the field.
	echo "Enter [$switch2]: $help (or 'remove' to remove it)"
	read CHOOSE
	if [ -z "$CHOOSE" ]; then
		echo No change to [$switch2]
	else
		if [ "$CHOOSE" == "remove" ]; then
			echo Remove [$switch2]
			id3v2 --remove-frame $switch2 "$FILE"
		else
			echo Set [$switch2] to $CHOOSE
			id3v2 --$switch2 "$CHOOSE" "$FILE"
			# TODO confirm it's ok by showing it back to user and asking to do it again...
		fi
	fi
}

function update_both_fields {
	local switch1 switch2 help CHOOSE
	switch1="$1"
	switch2="$2"
	help="$3"
	echo ----------
	id3v2 --list-rfc822 "$FILE" | grep $switch2:
	echo "Enter $switch1[$switch2]: $help (or 'remove' to remove it)"
	read CHOOSE
	if [ -z "$CHOOSE" ]; then
		echo No change to $switch1[$switch2]
	else
		if [ "$CHOOSE" == "remove" ]; then
			echo Remove [$switch2]
			id3v2 --remove-frame $switch2 "$FILE"
		else
			echo Set $switch1[$switch2] to $CHOOSE
			id3v2 --$switch1 "$CHOOSE" --$switch2 "$CHOOSE" "$FILE"
		fi
	fi
}

function update_comment {
	local switch1 switch2 CHOOSE
	switch1="comment"
	switch2="COMM"
	echo ----------
	id3v2 --list-rfc822 "$FILE" | grep $switch2
	echo "Enter description:$switch1:language [description and language are optional]"
	read CHOOSE
	if [ -z "$CHOOSE" ]; then
		echo No change to $switch1[$switch2]
	else
		echo Set $switch1[$switch2] to $CHOOSE
		id3v2 --$switch1 "$CHOOSE" "$FILE"
	fi
}

function update_genre {
	local swtich2 WC NUM CHOOSE
	switch2="TCON"
	echo ----------
	id3v2 --list-rfc822 "$FILE" | grep $switch2
	echo "Enter genre name or number (or 'remove' to remove it)"
	read CHOOSE
	if [ -z "$CHOOSE" ]; then
		echo No change to genre
	else
		if [ "$CHOOSE" == "remove" ]; then
			echo Remove genre
			id3v2 --genre 255 "$FILE"
		else
			id3v2 --list-genres | grep -i "$CHOOSE"
			WC=`id3v2 --list-genres | grep -i "$CHOOSE" | wc -l`
			if [ "$WC" == "1" ]; then
				NUM=`id3v2 --list-genres | grep -i "$CHOOSE" | perl -pne 's{:.+\z}{}xms'`
				echo Set genre to $NUM
				id3v2 --genre $NUM "$FILE"
			else
				update_genre
			fi
		fi
	fi
}

id3v2 --list "$FILE"
echo ==========
# https://id3.org/id3v2.3.0
update_both_fields year TYER "Year"
update_v2_field TPOS "Part of a set (num or num/num for 1/3 CD)"
update_both_fields track TRCK "Track number num or num/num for Total tracks"
update_both_fields artist TPE1 "Lead performer(s)/Soloist(s) (Separate with /)"
update_both_fields album TALB "Album/Movie/Show title"
update_genre
update_both_fields song TIT2 "Title/songname/content description"
update_v2_field TIT1 "Content group description (Piano Concerto, Weather - Hurricane)"
update_v2_field TIT3 "Subtitle/Description refinement (Op 16, Performed live at Wembley)"
update_comment
update_v2_field TCOM "Composer (Separate with /)"
update_v2_field TPE2 "Band/orchestra/accompaniment"
update_v2_field TPE3 "Conductor/performer refinement"
update_v2_field TOPE "Original Artist(s) or Performer(s) (Separate with /)"
update_v2_field TOAL "Original album/movie/show title"
update_v2_field TORY "Original release year"
update_v2_field TPUB "Publisher"
update_v2_field TENC "Encoded by"
update_v2_field TCON "Content type (overrides Genre)"
update_v2_field WOAR "Official artist/performer webpage"
update_v2_field WOAS "Official audio source webpage"
update_v2_field WOAF "Official audio file webpage"
update_v2_field WPUB "Official publisher webpage"
update_v2_field WXXX "User defined URL link"
echo ==========
id3v2 --list "$FILE"

exit 0
