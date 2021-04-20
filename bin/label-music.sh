#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# Add meta data to a song / music file that has little to none aleady.

# TODO
# Ask if original or cover at start and then omit all the Original X fields
# Ask if correct before moving on to next setting
# Show the stored value before moving on
# Show the comman argument as it is set
# Add TOFN TLAN

FILE="$1"

function usage {
	cmd=`basename $0`
	echo "
$cmd filename

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


function ask {
	local message
	message="$1"
	echo "$message [Y/n]? "
	read CHOOSE
	case "$CHOOSE" in
		y) CHOOSE=1;;
		Y) CHOOSE=1;;
		yes) CHOOSE=1;;
		Yes) CHOOSE=1;;
		YES) CHOOSE=1;;
		*) CHOOSE="";;
	esac
}

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
			id3v2 --list-rfc822 "$FILE" | grep "$switch2: "
			ask "Do you want to change it"
			if [ ! -z "$CHOOSE" ]; then
				update_v2_field "$switch2" "$help"
			fi
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
		id3v2 --list-rfc822 "$FILE" | grep "$switch2: "
		ask "Do you want to change it"
		if [ ! -z "$CHOOSE" ]; then
			update_both_fields "$switch1" "$switch2" "$help"
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
	id3v2 --list-rfc822 "$FILE" | grep "$switch2: "
	ask "Do you want to change it"
	if [ ! -z "$CHOOSE" ]; then
		update_comment
	fi
}

function update_genre {
	local swtich2 WC NUM CHOOSE
	switch2="TCON"
	echo ----------
	id3v2 --list-rfc822 "$FILE" | grep $switch2
	echo "Enter genre name and/or number (or 'remove' to remove it)"
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

ask "Is this a cover or remix of an earlier original"
COVER="$CHOOSE"
echo $COVER
if [ -z "$COVER" ]; then
	ask "Is this an original recording"
	RECORDING="$CHOOSE"
fi
ask "Do you have lyrics to add"
LYRICS="$CHOOSE"

id3v2 --list "$FILE"
echo ==========
# https://id3.org/id3v2.3.0
update_v2_field TOFN "Original long file name including .extension"
update_v2_field TLAN "Language code(s) eg. eng (Separate with /)"
update_both_fields year TYER "Year"

if [ ! -z "$COVER" ]; then
	update_v2_field TOPE "Original Artist(s) or Performer(s) (Separate with /)"
	update_v2_field TOAL "Original album/movie/show title"
	update_v2_field TORY "Original release year"
	update_v2_field TOLY "Original lyricist/text Writer(s)"
	update_v2_field TPE4 "Interpreter/Remixer/Other modifier"
fi

if [ ! -z "$RECORDING" ]; then
	update_v2_field TOWN "Owner or Licensee"
	update_v2_field TCOP "Copyright date (include a trailing space)"
	update_v2_field TDAT "Recording date DDMM"
	update_v2_field TIME "Recording time HHMM"
	update_v2_field TKEY "Initial musical key (3 chars) A-G b# m i.e. A#m for A sharp minor"
	update_v2_field TBPM "Beats per minute of main part of the audio"
fi

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

update_v2_field TPUB "Publisher"
update_v2_field TENC "Encoded by"
update_v2_field TEXT "Lyricist/Text Writer(s)"
update_v2_field TCON "Content type (overrides Genre)"
echo " "
echo "You can use the urldecode command to unescape any redirect tracking url you need to convert."
echo " "
update_v2_field WOAR "Official artist/performer webpage"
update_v2_field WOAF "Official audio file webpage"
update_v2_field WOAS "Official audio source webpage"
update_v2_field WPUB "Official publisher webpage"
if [ ! -z "$LYRICS" ]; then
	echo Paste your lyrics now and press Ctrl-D.
	label-lyrics.sh "$FILE" "`cat`"
	echo " "
	ask "Do you want to change them"
	if [ ! -z "$CHOOSE" ]; then
		label-lyrics.sh "$FILE" "`cat`"
	fi
fi
echo ==========
id3v2 --list "$FILE"

exit 0
