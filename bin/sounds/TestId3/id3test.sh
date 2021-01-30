#!/bin/bash

# Test ID3 tag frames showing any special formats required.

# Frame notes sourced from:
# https://id3.org/id3v2.3.0#Text_information_frames_-_details

# Version 1 tags:
# === TALB (Album/Movie/Show title): ALBUM
# === TRCK (Track number/Position in set): 1
# === TIT2 (Title/songname/content description): SONG
# === TPE1 (Lead performer(s)/Soloist(s)): ARTIST
# === TYER (Year): 2001
# === TCON (Content type): (101)
# === COMM (Comments): (ID3v1 Comment)[XXX]: COMMENT

# Free Form Text:
# ===============

# --album --TALB The 'Album/Movie/Show title' frame is intended for the title of the recording(/source of sound) which the audio in the file is taken from.
ALBUM="ALBUM MOVIE SHOW TITLE 123456789012345678901234567890"

# --artist --TPE1 The 'Lead artist(s)/Lead performer(s)/Soloist(s)/Performing group' is used for the main artist(s). They are separated with the "/" character.
ARTIST="ARTIST1/ARTIST2 123456789012345678901234567890" # --TPE1 or --artist

# --song --TIT2 The 'Title/Songname/Content description' frame is the actual name of the piece (e.g. "Adagio", "Hurricane Donna").

TITLE="SONG TITLE 123456789012345678901234567890" \

# --TIT1 The 'Content group description' frame is used if the sound belongs to a larger category of sounds/music. For example, classical music is often sorted in different musical sections (e.g. "Piano Concerto", "Weather - Hurricane").
TIT1="GROUPING TYPE"

# --TIT3 The 'Subtitle/Description refinement' frame is used for information directly related to the contents title (e.g. "Op. 16" or "Performed live at Wembley").
TIT3="SUBTITLE or REFINEMENT"

# --TCOM The 'Composer(s)' frame is intended for the name of the composer(s). They are separated with the "/" character.
TCOM="COMPOSER1/COMPOSER2"

# --TPE2 The 'Band/Orchestra/Accompaniment' frame is used for additional information about the performers in the recording.
TPE2="PERFORMER1/PERFORMER2"

# --TOPE The 'Original artist(s)/performer(s)' frame is intended for the performer(s) of the original recording, if for example the music in the file should be a cover of a previously released song. The performers are separated with the "/" character.
TOPE="ORG SINGER1/ORG BAND1"

# --TOAL The 'Original album/movie/show title' frame is intended for the title of the original recording (or source of sound), if for example the music in the file should be a cover of a previously released song.
TOAL="ORG ALBUM1"

# --TPUB The 'Publisher' frame simply contains the name of the label or publisher.
TPUB="PUBLISHER"

#--TENC The 'Encoded by' frame contains the name of the person or organisation that encoded the audio file. This field may contain a copyright message, if the audio file also is copyrighted by the encoder.
TENC="ENCODER (c) optional"

# --TEXT The 'Lyricist(s)/Text writer(s)' frame is intended for the writer(s) of the text or lyrics in the recording. They are separated with the "/" character.
TEXT="WRITER1/LYRICIST2"

# --TOLY The 'Original lyricist(s)/text writer(s)' frame is intended for the text writer(s) of the original recording, if for example the music in the file should be a cover of a previously released song. The text writers are separated with the "/" character.
TOLY="ORG WRITER1/LYRICIST2"

# --TOFN The 'Original filename' frame contains the preferred filename for the file, since some media doesn't allow the desired length of the filename. The filename is case sensitive and includes its suffix.
TOFN='The original long name of the file with weird characters !£$££$HOME%x.mp3'

# --TOWN The 'File owner/licensee' frame contains the name of the owner or licensee of the file and it's contents.
TOWN="OWNER/LICENSEE"

# --TPE3 The 'Conductor' frame is used for the name of the conductor.
TPE3="CONDUCTOR"

# --TPE4 The 'Interpreted, remixed, or otherwise modified by' frame contains more information about the people behind a remix and similar interpretations of another existing piece.
TPE4="INTERPRETER1/REMIXER2/MODIFIER3"

# --TRDA The 'Recording dates' frame is intended to be used as complement to the "TYER", "TDAT" and "TIME" frames. E.g. "4th-7th June, 12th June" in combination with the "TYER" frame.
TRDA="4th-7th,12th June"

# --TRSN The 'Internet radio station name' frame contains the name of the internet radio station from which the audio is streamed.
TRSN="INTERNET RADIO STATION NAME"

# --TRSO The 'Internet radio station owner' frame contains the name of the owner of the internet radio station from which the audio is streamed.
TRSO="STATION OWNER"

# --TSSE The 'Software/Hardware and settings used for encoding' frame includes the used audio encoder and its settings when the file was encoded. Hardware refers to hardware encoders, not the computer on which a program was run.
TSSE="SW/HW SETTINGS"

# Specific Format Requirements:
# =============================

# --genre A single ID3v1 genre number will be stored in the TCON frame
# --TCON The 'Content type', which previously was stored as a one byte numeric value only, is now a numeric string. You may use one or several of the types as ID3v1.1 did or, since the category list would be impossible to maintain with accurate and up to date categories, define your own.
# Defines two new genres: Cover (CR) and Remix (RX)
# NOTE HOWEVER: id3v2 program only supports a single number. Otherwise it sets genre ID 255 and stores the text as is.

GENRE=1
TCON="(1)"
# TCON multi value not working.
GENRES="(101)Lecture"  # becomes Speech (101)
GENRES="(CR)(1)(24)(67)(RX)"  # becomes Unknown (255)  (CR)(1)(24)(67)(RX)
#TCON="$GENRES"

# --year --TYER The 'Year' frame is a numeric string with a year of the recording. This frames is always four characters long (until the year 10000).
YEAR=19999

# --track --TRCK The 'Track number/Position in set' frame is a numeric string containing the order number of the audio-file on its original recording. This may be extended with a "/" character and a numeric string containing the total numer of tracks/elements on the original recording. E.g. "4/9".
TRACK="1/100"

# --TPOS TPOS The 'Part of a set' frame is a numeric string that describes which part of a set the audio came from. This frame is used if the source described in the "TALB" frame is divided into several mediums, e.g. a double CD. The value may be extended with a "/" character and a numeric string containing the total number of parts in the set. E.g. "1/2".
TPOS="1/3" # CD set

# --comment -COMM "DESCRIPTION":"COMMENT":"LANGUAGE" LANGUAGE limited to three characters
# --COMM This frame is indended for any kind of full text information that does not fit in any other frame. It consists of a frame header followed by encoding, language and content descriptors and is ended with the actual comment as a text string. Newline characters are allowed in the comment text string. There may be more than one comment frame in each tag, but only one with the same language and content descriptor.
# [ISO-639-2] ISO/FDIS 639-2. Codes for the representation of names of languages, Part 2: Alpha-3 code. Technical committee / subcommittee: TC 37 / SC 2
# https://www.loc.gov/standards/iso639-2/php/code_list.php
COMMENT="Comment information with
no description or language
and multiple lines"
COMMENT1="DESC:Comment with description"
COMMENT2="DESC:Commentaire avec description et langue:fre"

# --TORY The 'Original release year' frame is intended for the year when the original recording, if for example the music in the file should be a cover of a previously released song, was released. The field is formatted as in the "TYER" frame.
TORY=1909

# --TBPM The 'BPM' frame contains the number of beats per minute in the mainpart of the audio. The BPM is an integer and represented as a numerical string.
TBPM=240

# --TCOP The 'Copyright message' frame, which must begin with a year and a space character (making five characters), is intended for the copyright holder of the original sound, not the audio file itself. The absence of this frame means only that the copyright information is unavailable or has been removed, and must not be interpreted to mean that the sound is public domain. Every time this field is displayed the field must be preceded with "Copyright © ".
TCOP="1924 "

# --TDAT The 'Date' frame is a numeric string in the DDMM format containing the date for the recording. This field is always four characters long.
TDAT="0112"

# --TDLY The 'Playlist delay' defines the numbers of milliseconds of silence between every song in a playlist. The player should use the "ETC" frame, if present, to skip initial silence and silence at the end of the audio to match the 'Playlist delay' time. The time is represented as a numeric string.
TDLY="923"

# --TFLT The 'File type' frame indicates which type of audio this tag defines. The following type and refinements are defined:
# MPG /1 /2 /3 /2.5 /AAC VQF PCM
TFLT="(MPG/3) and Refinement"

# --TIME The 'Time' frame is a numeric string in the HHMM format containing the time for the recording. This field is always four characters long.
TIME="0314"

# --TKEY The 'Initial key' frame contains the musical key in which the sound starts. It is represented as a string with a maximum length of three characters. The ground keys are represented with "A","B","C","D","E", "F" and "G" and halfkeys represented with "b" and "#". Minor is represented as "m". Example "Cbm". Off key is represented with an "o" only.
TKEY=Abm

# --TLAN The 'Language(s)' frame should contain the languages of the text or lyrics spoken or sung in the audio. The language is represented with three characters according to ISO-639-2. If more than one language is used in the text their language codes should follow according to their usage.
TLAN="spa/eng"

# --TLEN The 'Length' frame contains the length of the audiofile in milliseconds, represented as a numeric string.
TLEN=184821

# --TMED The 'Media type' frame describes from which media the sound originated. This may be a text string or a reference to the predefined media types found in the list below. References are made within "(" and ")" and are optionally followed by a text refinement, e.g. "(MC) with four channels". If a text refinement should begin with a "(" character it should be replaced with "((" in the same way as in the "TCO" frame. Predefined refinements is appended after the media type, e.g. "(CD/A)" or "(VID/PAL/VHS)".
TMED="(VID/PAL/VHS) with background noise"

# --TSIZ The 'Size' frame contains the size of the audiofile in bytes, excluding the ID3v2 tag, represented as a numeric string.
TSIZ=3984123

# --TSRC The 'ISRC' frame should contain the International Standard Recording Code (ISRC) (12 characters).
# https://en.wikipedia.org/wiki/International_Standard_Recording_Code#Format
TSRC="CCXXXYYNNNNN" \

# --USER "LANGUAGE":"TERMS" LANGUAGE limited to three characters
# This frame contains a brief description of the terms of use and ownership of the file. More detailed information concerning the legal terms might be available through the "WCOP" frame. Newlines are allowed in the text. There may only be one "USER" frame in a tag.
USER="eng:Legal terms of use and ownership
with multiple lines and a language identifier."

# --USLT "DESCRIPTION":"LYRICS OR TRANSCRIPT":"LANGUAGE" LANGUAGE limited to three characters
# This frame contains the lyrics of the song or a text transcription of other vocal activities. The head includes an encoding descriptor and a content descriptor. The body consists of the actual text. The 'Content descriptor' is a terminated string. If no descriptor is entered, 'Content descriptor' is $00 (00) only. Newline characters are allowed in the text. There may be more than one 'Unsynchronised lyrics/text transcription' frame in each tag, but only one with the same language and content descriptor.
USLT="Lyrics:
Unsynchronised Lyrics with multiple
lines and language
:eng"
USLT2="Transcript:
Full Transcript with
multiple lines and language
:eng"

# URL Frames:
# ===========

#--WOAR The 'Official artist/performer webpage' frame is a URL pointing at the artists official webpage. There may be more than one "WOAR" frame in a tag if the audio contains more than one performer, but not with the same content.
WOAR="http://test.com/official/artist1/webpage"
WOAR2="http://test.com/official/artist2/webpage"

# --WOAS The 'Official audio source webpage' frame is a URL pointing at the official webpage for the source of the audio file, e.g. a movie.
WOAS="http://test.com/official/audio/site"

# --WOAF The 'Official audio file webpage' frame is a URL pointing at a file specific webpage.
WOAF="http://test.com/official/audio/download"

# --WPUB The 'Publishers official webpage' frame is a URL pointing at the official wepage for the publisher.
WPUB="http://test.com/official/publisher/webpage"

# --WCOM The 'Commercial information' frame is a URL pointing at a webpage with information such as where the album can be bought. There may be more than one "WCOM" frame in a tag, but not with the same content.
WCOM="http://test.com/purchase/here"
WCOM2="http://test.com/purchase/here/too"

# --WCOP The 'Copyright/Legal information' frame is a URL pointing at a webpage where the terms of use and ownership of the file is described.
WCOP="http://test.com/copyright/legal-terms/info/here"

# --WORS The 'Official internet radio station homepage' contains a URL pointing at the homepage of the internet radio station.
WORS="http://test.com/internet/radio/station/homepage"

# --WPAY The 'Payment' frame is a URL pointing at a webpage that will handle the process of paying for this file.
WPAY="http://test.com/pay/here"

# Unimplemented or not fully working:
# ===================================

echo Incomplete/no support as per spec.\
	--TCON "$GENRES" \
	--WXXX "$WXXX" \
	--WXXX "$WXXX2" \
	--WXXX "$WXXX3" \
	--TXXX "$TXXX" \
	--TXXX "$TXXX1" \
	--TXXX "$TXXX2" \
	> /dev/null

#		--APIC "APIC ATTACHED PICTURE" \
#		--AENC "AENC AUDIO ENCRYPTION" \
#		--COMR "COMR COMMERCIAL FRAME" \ unrecignised
#		--ENCR "ENCR ENCRYPTION METHOD REGISTRATION" \
#		--EQUA "EQUA EQUALIZATION" \
#		--ETCO "ETCO EVENT TIMING CODES" \
#		--GEOB "GEOB GENERAL ENCAPSULATED OBJECT" \
#		--GRID "GRID GROUP IDENTIFICATION REGISTRATION" \
#		--IPLS "IPLS INVOLVED PEOPLE LIST" \
#		--LINK "LINK LINKED INFORMATION" \
#		--MCDI "MCDI MUSIC CD IDENTIFIER" \
#		--MLLT "MLLT MPEG LOCATION LOOKUP TABLE" \
#		--OWNE "OWNE OWNERSHIP FRAME" \
#		--PCNT "PCNT PLAY COUNTER" \
#		--POPM "POPM POPULARIMETER" \
#		--POSS "POSS POSITION SYNCHRONISATION FRAME" \
#		--PRIV "PRIV PRIVATE FRAME" \
#		--RBUF "RBUF RECOMMENDED BUFFER SIZE" \
#		--RVAD "RVAD RELATIVE VOLUME ADJUSTMENT" \
#		--RVRB "RVRB REVERB" \
#		--SYLT "SYLT SYNCHRONIZED LYRIC/TEXT" \
#		--SYTC "SYTC SYNCHRONIZED TEMPO CODES" \
#		--WXXX "WXXX USER DEFINED URL LINK" \
#		--TXXX "TXXX USER DEFINED TEXT FIELDS" \
#		--UFID "UFID UNIQUE FILE IDENTIFIER" \

# --WXXX "DESC:URL" This frame is intended for URL links concerning the audiofile in a similar way to the other "W"-frames. The frame body consists of a description of the string, represented as a terminated string, followed by the actual URL. The URL is always encoded with ISO-8859-1. There may be more than one "WXXX" frame in each tag, but only one with the same description.
WXXX="http://test.com/official/artist/biography"
WXXX2="BandHistory:http://test.com/official/band/history"
WXXX3="ArtistBio:http://test.com/official/artist/biography"

# --TXXX "DESCRIPTION:TEXT"
# This frame is intended for one-string text information concerning the audiofile in a similar way to the other "T"-frames. The frame body consists of a description of the string, represented as a terminated string, followed by the actual string. There may be more than one "TXXX" frame in each tag, but only one with the same description.
# NOTE HOWEVER: in id3v2 program it is not working to store differently labelled values, only one is saved.
TXXX="TXXX User Defined Text Information"
TXXX1="TXXX1:User Defined Text Information 1"
TXXX2="TXXX2:User Defined Text Information 2
WITH TWO LInES"

id3v2 --delete-all TestId3.mp3


id3v2 \
	--album "$ALBUM" \
	--song "$TITLE" \
	--artist "$ARTIST" \
	--genre "$GENRE" \
	--year "$YEAR" \
	--track "$TRACK" \
	--comment "$COMMENT" \
	--comment "$COMMENT1" \
	--comment "$COMMENT2" \
	--TPOS "$TPOS" \
	--TIT1 "$TIT1" \
	--TIT3 "$TIT3" \
	--TCOM "$TCOM" \
	--TPE2 "$TPE2" \
	--TOPE "$TOPE" \
	--TOAL "$TOAL" \
	--TORY "$TORY" \
	--TPUB "$TPUB" \
	--TENC "$TENC" \
	--WOAR "$WOAR" \
	--WOAR "$WOAR2" \
	--WOAS "$WOAS" \
	--WOAF "$WOAF" \
	--WPUB "$WPUB" \
	--TBPM "$TBPM" \
	--TCOP "$TCOP" \
	--TDAT "$TDAT" \
	--TDLY "$TDLY" \
	--TEXT "$TEXT" \
	--TFLT "$TFLT" \
	--TIME "$TIME" \
	--TKEY "$TKEY" \
	--TLAN "$TLAN" \
	--TLEN "$TLEN" \
	--TMED "$TMED" \
	--TOFN "$TOFN" \
	--TOLY "$TOLY" \
	--TOWN "$TOWN" \
	--TPE3 "$TPE3" \
	--TPE4 "$TPE4" \
	--TRDA "$TRDA" \
	--TRSN "$TRSN" \
	--TRSO "$TRSO" \
	--TSIZ "$TSIZ" \
	--TSRC "$TSRC" \
	--TSSE "$TSSE" \
	--TXXX "$TXXX1" \
	--USER "$USER" \
	--USLT "$USLT" \
	--USLT "$USLT2" \
	--WCOM "$WCOM" \
	--WCOM "$WCOM2" \
	--WCOP "$WCOP" \
	--WORS "$WORS" \
	--WPAY "$WPAY" \
	TestId3.mp3

#	--TCON "$TCON" \


perl -e 'print qq{\n\n}'
id3v2 --list TestId3.mp3

id3v2 -R TestId3.mp3 | filter-id3.pl > id3test.out.sh
chmod +x id3test.out.sh
less id3test.out.sh

exit
#==========================================================================





id3v2 --list-genres
  0: Blues
  1: Classic Rock
  2: Country
  3: Dance
  4: Disco
  5: Funk
  6: Grunge
  7: Hip-Hop
  8: Jazz
  9: Metal
 10: New Age
 11: Oldies
 12: Other
 13: Pop
 14: R&B
 15: Rap
 16: Reggae
 17: Rock
 18: Techno
 19: Industrial
 20: Alternative
 21: Ska
 22: Death Metal
 23: Pranks
 24: Soundtrack
 25: Euro-Techno
 26: Ambient
 27: Trip-Hop
 28: Vocal
 29: Jazz+Funk
 30: Fusion
 31: Trance
 32: Classical
 33: Instrumental
 34: Acid
 35: House
 36: Game
 37: Sound Clip
 38: Gospel
 39: Noise
 40: AlternRock
 41: Bass
 42: Soul
 43: Punk
 44: Space
 45: Meditative
 46: Instrumental Pop
 47: Instrumental Rock
 48: Ethnic
 49: Gothic
 50: Darkwave
 51: Techno-Industrial
 52: Electronic
 53: Pop-Folk
 54: Eurodance
 55: Dream
 56: Southern Rock
 57: Comedy
 58: Cult
 59: Gangsta
 60: Top 40
 61: Christian Rap
 62: Pop/Funk
 63: Jungle
 64: Native American
 65: Cabaret
 66: New Wave
 67: Psychedelic
 68: Rave
 69: Showtunes
 70: Trailer
 71: Lo-Fi
 72: Tribal
 73: Acid Punk
 74: Acid Jazz
 75: Polka
 76: Retro
 77: Musical
 78: Rock & Roll
 79: Hard Rock
 80: Folk
 81: Folk-Rock
 82: National Folk
 83: Swing
 84: Fast Fusion
 85: Bebob
 86: Latin
 87: Revival
 88: Celtic
 89: Bluegrass
 90: Avantgarde
 91: Gothic Rock
 92: Progressive Rock
 93: Psychedelic Rock
 94: Symphonic Rock
 95: Slow Rock
 96: Big Band
 97: Chorus
 98: Easy Listening
 99: Acoustic
100: Humour
101: Speech
102: Chanson
103: Opera
104: Chamber Music
105: Sonata
106: Symphony
107: Booty Bass
108: Primus
109: Porn Groove
110: Satire
111: Slow Jam
112: Club
113: Tango
114: Samba
115: Folklore
116: Ballad
117: Power Ballad
118: Rhythmic Soul
119: Freestyle
120: Duet
121: Punk Rock
122: Drum Solo
123: A capella
124: Euro-House
125: Dance Hall
126: Goa
127: Drum & Bass
128: Club-House
129: Hardcore
130: Terror
131: Indie
132: Britpop
133: Negerpunk
134: Polsk Punk
135: Beat
136: Christian Gangsta Rap
137: Heavy Metal
138: Black Metal
139: Crossover
140: Contemporary Christian
141: Christian Rock
142: Merengue
143: Salsa
144: Thrash Metal
145: Anime
146: JPop
147: Synthpop
