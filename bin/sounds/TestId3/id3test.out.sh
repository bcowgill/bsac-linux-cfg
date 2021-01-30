# See details on meanings of different frame names: https://id3.org/id3v2.3.0#Text_information_frames_-_details
# TestId3.mp3   ID3v2
id3v2 \
	--TALB "ALBUM MOVIE SHOW TITLE 123456789012345678901234567890" \
	--TIT2 "SONG TITLE 123456789012345678901234567890" \
	--TPE1 "ARTIST1/ARTIST2 123456789012345678901234567890" \
	--TCON "(1)" \
	--TYER "19999" \
	--TRCK "1/100" \
	--COMM "Comment information with
no description or language
and multiple lines" \
	--COMM "DESC:Comment with description" \
	--COMM "DESC:Commentaire avec description et langue:fre" \
	--TPOS "1/3" \
	--TIT1 "GROUPING TYPE" \
	--TIT3 "SUBTITLE or REFINEMENT" \
	--TCOM "COMPOSER1/COMPOSER2" \
	--TPE2 "PERFORMER1/PERFORMER2" \
	--TOPE "ORG SINGER1/ORG BAND1" \
	--TOAL "ORG ALBUM1" \
	--TORY "1909" \
	--TPUB "PUBLISHER" \
	--TENC "ENCODER (c) optional" \
	--WOAR "http://test.com/official/artist1/webpage" \
	--WOAR "http://test.com/official/artist2/webpage" \
	--WOAS "http://test.com/official/audio/site" \
	--WOAF "http://test.com/official/audio/download" \
	--WPUB "http://test.com/official/publisher/webpage" \
	--TBPM "240" \
	--TCOP "1924 " \
	--TDAT "0112" \
	--TDLY "923" \
	--TEXT "WRITER1/LYRICIST2" \
	--TFLT "(MPG/3) and Refinement" \
	--TIME "0314" \
	--TKEY "Abm" \
	--TLAN "spa/eng" \
	--TLEN "184821" \
	--TMED "(VID/PAL/VHS) with background noise" \
	--TOFN "The original long name of the file with weird characters !£$££$HOME%x.mp3" \
	--TOLY "ORG WRITER1/LYRICIST2" \
	--TOWN "OWNER/LICENSEE" \
	--TPE3 "CONDUCTOR" \
	--TPE4 "INTERPRETER1/REMIXER2/MODIFIER3" \
	--TRDA "4th-7th,12th June" \
	--TRSN "INTERNET RADIO STATION NAME" \
	--TRSO "STATION OWNER" \
	--TSIZ "3984123" \
	--TSRC "CCXXXYYNNNNN" \
	--TSSE "SW/HW SETTINGS" \
	--TXXX "TXXX1:User Defined Text Information 1" \
	--USER "eng:Legal terms of use and ownership
with multiple lines and a language identifier." \
	--USLT "(Lyrics)[eng]:
Unsynchronised Lyrics with multiple
lines and language
" \
	--USLT "(Transcript)[eng]:
Full Transcript with
multiple lines and language
" \
	--WCOM "http://test.com/purchase/here" \
	--WCOM "http://test.com/purchase/here/too" \
	--WCOP "http://test.com/copyright/legal-terms/info/here" \
	--WORS "http://test.com/internet/radio/station/homepage" \
	TestId3.mp3
