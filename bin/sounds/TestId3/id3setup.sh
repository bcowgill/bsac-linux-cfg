#!/bin/bash

# rm *.mp3; git co TestId3Empty.mp3
# ./id3setup.sh > id3setup.log

# produce all v2 frames as command line args...
# id3v2 --list-frames | perl -pne 'chomp; $_ = uc($_); s{--(\w+)\s+(.+)\z}{--$1 "$1 $2" \\\n}xms'

# https://id3.org/id3v2.3.0#Text_information_frames_-_details

# Version 1 tags:
# === TIT2 (Title/songname/content description): SONG
# === TPE1 (Lead performer(s)/Soloist(s)): ARTIST
# === TALB (Album/Movie/Show title): ALBUM
# === TYER (Year): 2001
# === TRCK (Track number/Position in set): 1
# === COMM (Comments): (ID3v1 Comment)[XXX]: COMMENT
# === TCON (Content type): (101)

# TODO Check the output of v1 tagging and v2 tagging using filter-id3.pl to check it is working correctly
# TODO TestId3v1and2.mp3
# TODO TestId3 v2.mp3

id3v2 --delete-all TestId3Empty.mp3

function tag1nodesc {
	local filename option
	filename="$1"
	option="$2"
	echo " "
	echo TAG "$filename" $option
	id3tag \
		$option \
		--artist ARTISTv1 \
		--song SONGv1 \
		--album ALBUMv1 \
		--comment "COMMENTv1
NODESC v1" \
		--genre 101 \
		--year 2001 \
		--track 1 \
		--total 10 \
		"$filename"
}

function tag1 {
	local filename option
	filename="$1"
	option="$2"
	echo " "
	echo TAG "$filename" $option
	id3tag \
		$option \
		--artist ARTISTv1 \
		--song SONGv1 \
		--album ALBUMv1 \
		--desc DESCRIPTIONv1 \
		--comment "COMMENTv1
WITH DESCRIPTION v1" \
		--genre 102 \
		--year 2002 \
		--track 2 \
		--total 11 \
		"$filename"
}

function tag2 {
	local filename option
	filename="$1"
	option="$2"
	echo " "
	echo TAG2 "$filename" $option

	id3v2 \
		$option \
		--artist ARTISTv2 \
		--song SONGv2 \
		--album ALBUMv2 \
		--comment DESCRIPTIONv2:COMMENTv2 \
		--genre 143 \
		--year 2201 \
		--track 3/12 \
		--TIT2 "TIT2 TITLE/SONGNAME/CONTENT DESCRIPTION" \
		--TPE1 "TPE1 LEAD PERFORMER(S)/SOLOIST(S)" \
		--TALB "TALB ALBUM/MOVIE/SHOW TITLE" \
		--TYER "TYER YEAR" \
		--TRCK "TRCK TRACK NUMBER/POSITION IN SET" \
		--COMM "COMM COMMENTS" \
		--COMM "LABEL1:COMM COMMENTS:eng" \
		--COMM "LABEL2:COMM COMMENTS
WITH TWO LINES:eng" \
		--TCON "TCON CONTENT TYPE" \
		--TBPM "TBPM BPM (BEATS PER MINUTE)" \
		--TCOM "TCOM COMPOSER" \
		--TCOP "TCOP COPYRIGHT MESSAGE" \
		--TDAT "TDAT DATE" \
		--TDLY "TDLY PLAYLIST DELAY" \
		--TENC "TENC ENCODED BY" \
		--TEXT "TEXT LYRICIST/TEXT WRITER" \
		--TFLT "TFLT FILE TYPE" \
		--TIME "TIME TIME" \
		--TIT1 "TIT1 CONTENT GROUP DESCRIPTION" \
		--TIT3 "TIT3 SUBTITLE/DESCRIPTION REFINEMENT" \
		--TKEY "TKEY INITIAL KEY" \
		--TLAN "TLAN LANGUAGE(S)" \
		--TLEN "TLEN LENGTH" \
		--TMED "TMED MEDIA TYPE" \
		--TOAL "TOAL ORIGINAL ALBUM/MOVIE/SHOW TITLE" \
		--TOFN "TOFN ORIGINAL FILENAME" \
		--TOLY "TOLY ORIGINAL LYRICIST(S)/TEXT WRITER(S)" \
		--TOPE "TOPE ORIGINAL ARTIST(S)/PERFORMER(S)" \
		--TORY "TORY ORIGINAL RELEASE YEAR" \
		--TOWN "TOWN FILE OWNER/LICENSEE" \
		--TPE2 "TPE2 BAND/ORCHESTRA/ACCOMPANIMENT" \
		--TPE3 "TPE3 CONDUCTOR/PERFORMER REFINEMENT" \
		--TPE4 "TPE4 INTERPRETED, REMIXED, OR OTHERWISE MODIFIED BY" \
		--TPOS "TPOS PART OF A SET" \
		--TPUB "TPUB PUBLISHER" \
		--TRDA "TRDA RECORDING DATES" \
		--TRSN "TRSN INTERNET RADIO STATION NAME" \
		--TRSO "TRSO INTERNET RADIO STATION OWNER" \
		--TSIZ "TSIZ SIZE" \
		--TSRC "TSRC ISRC (INTERNATIONAL STANDARD RECORDING CODE)" \
		--TSSE "TSSE SOFTWARE/HARDWARE AND SETTINGS USED FOR ENCODING" \
		--TXXX "LABEL1:TXXX USER DEFINED TEXT INFORMATION
WITH TWO LINES
ONLY ONE VALUE WORKING" \
		--USER "eng:USER TERMS OF USE
WITH TWO LINES
ONLY ONE VALUE ALLOWED" \
		--USLT "LABEL1:USLT UNSYNCHRONIZED LYRIC/TEXT TRANSCRIPTION:eng" \
		--USLT "LABEL2:USLT UNSYNCHRONIZED LYRIC/TEXT TRANSCRIPTION
WITH TWO LINES:eng" \
		--WCOM "WCOM COMMERCIAL INFORMATION URL" \
		--WCOM "WCOM COMMERCIAL INFORMATION ANOTHER VALUE URL" \
		--WCOP "WCOP COPYRIGHT/LEGAL INFORMATION URL" \
		--WOAF "WOAF OFFICIAL AUDIO FILE WEBPAGE URL" \
		--WOAR "WOAR OFFICIAL ARTIST/PERFORMER WEBPAGE URL" \
		--WOAR "WOAR OFFICIAL SECOND ARTIST/PERFORMER WEBPAGE URL" \
		--WOAS "WOAS OFFICIAL AUDIO SOURCE WEBPAGE URL" \
		--WORS "WORS OFFICIAL INTERNET RADIO STATION HOMEPAGE URL" \
		--WPAY "WPAY PAYMENT URL" \
		--WPUB "WPUB OFFICIAL PUBLISHER WEBPAGE URL" \
		"$filename"
}

function info12 {
	local filename
	filename="$1"
	echo " "
	echo === id3info $filename
	id3info "$filename"
	echo === id3v2 --list
	id3v2 --list "$filename"
	echo === id3v2 --list-rfc822
	id3v2 --list-rfc822 "$filename"
	echo === id3v2 --list-rfc822 filtered
	id3v2 --list-rfc822 "$filename" | INLINE=1 filter-id3.pl
	echo ================================================
}

cp TestId3Empty.mp3 TestId3Tagv1.mp3
cp TestId3Empty.mp3 TestId3Tagv1desc.mp3

cp TestId3Empty.mp3 TestId3Tagv2basic.mp3
cp TestId3Empty.mp3 TestId3Tagv2basicdesc.mp3

cp TestId3Empty.mp3 TestId3Tagv1and2basic.mp3
cp TestId3Empty.mp3 TestId3Tagv1and2basicdesc.mp3

cp TestId3Empty.mp3 TestId3v2.mp3


tag1nodesc TestId3Tagv1.mp3 --v1tag
tag1 TestId3Tagv1desc.mp3 --v1tag

tag1nodesc TestId3Tagv2basic.mp3 --v2tag
tag1 TestId3Tagv2basicdesc.mp3 --v2tag

tag1nodesc TestId3Tagv1and2basic.mp3
tag1 TestId3Tagv1and2basicdesc.mp3

tag2 TestId3v2.mp3

info12 TestId3Empty.mp3
info12 TestId3Tagv1.mp3
info12 TestId3Tagv1desc.mp3
exit
info12 TestId3v2basic.mp3
info12 TestId3v1and2basic.mp3
info12 TestId3v2.mp3

exit

id3v2 TestId3v1and2.mp3
TestId3Empty.mp3
TestId3.mp3
TestId3v1and2.mp3
TestId3v1.mp3
TestId3v2.mp3

#ID3TAG(1)                                                               User Command                                                              ID3TAG(1)



NAME
       id3tag - Tags an mp3 file with id3v1 and/or id3v2 tags.

SYNOPSIS
       id3tag [ OPTION ]...  [ FILE ]...

DESCRIPTION
       Id3tag  will  render  both  types  of  tag by default.  Only the last tag type indicated in the option list will be used.  Non- rendered will remain
       unchanged in the original file.  Will also parse and convert Lyrics3 v2.0 frames, but will not render them.


OPTIONS
       -1, --v1tag
              Render only the id3v1 tag

       -2, --v2tag
              Render only the id3v2 tag

       -a, --artist ARTIST
              Set the artist information

       -s, --song SONG
              Set the song title information

       -A, --album ALBUM
              Set the album title information

       -c, --comment COMMENT
              Set the comment information

       -C, --desc DESCRIPTION
              Set the comment description

       -g, --genre num
              Set the genre number

       -y, --year num
              Set the year

       -t, --track num
              Set the track number

       -T, --total num
              Set the total number of tracks on the album


SEE ALSO
       id3convert(1), id3info(1), id3v2(1)

AUTHOR
       id3lib was originally designed and implemented by Dirk Mahoney and is maintained by Scott Thomas Haug <sth2@cs.wustl.edu>. Manual page  written  for
       Debian GNU/Linux by Robert Woodcock <rcw@debian.org>.




local                                                                     May 2000                                                                ID3TAG(1)

TAG TestId3v1.mp3 --v1tag
+++ Artist  = ARTIST
+++ Album   = ALBUM
+++ Song    = SONG
+++ Year    = 2001
+++ Comment = COMMENT
+++ Comment Description
            = DESCRIPTION
+++ Genre   = 101
+++ Track   = 1
+++ Total   = 10
Tagging TestId3v1.mp3: attempting v1, tagged v1

TAG TestId3v2basic.mp3 --v2tag
+++ Artist  = ARTIST
+++ Album   = ALBUM
+++ Song    = SONG
+++ Year    = 2001
+++ Comment = COMMENT
+++ Comment Description
            = DESCRIPTION
+++ Genre   = 101
+++ Track   = 1
+++ Total   = 10


=== id3info TestId3v1.mp3

*** Tag information for TestId3v1.mp3
=== TIT2 (Title/songname/content description): SONG
=== TPE1 (Lead performer(s)/Soloist(s)): ARTIST
=== TALB (Album/Movie/Show title): ALBUM
=== TYER (Year): 2001
=== TRCK (Track number/Position in set): 1
=== COMM (Comments): (ID3v1 Comment)[XXX]: COMMENT
=== TCON (Content type): (101)
*** mp3 info
MPEG1/layer III
Bitrate: 128KBps
Frequency: 44KHz
=== id3v2 --list
id3v1 tag info for TestId3v1.mp3:
Title  : SONG                            Artist: ARTIST
Album  : ALBUM                           Year: 2001, Genre: Speech (101)
Comment: COMMENT                         Track: 1
TestId3v1.mp3: No ID3v2 tag
=== id3v2 --list-rfc822
TestId3v1.mp3: No ID3 tag
