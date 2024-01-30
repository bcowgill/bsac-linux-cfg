#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# see info about a file/dir/archive and view it if possible using system configure app or manually configured ones.
# see tests/see/in for sample file types.
# WINDEV tool useful on windows development machin

# set -x

ROWS=20

SEE="see"
LESS=less
META=ls-meta.sh
FEH=feh
WORD=libreoffice
EXCEL=libreoffice
PDFV=evince
BROWSER=browser.sh

if [ "$1" == "--test" ]; then
	shift
	HARNESS_ACTIVE=1
fi
if [ "$HARNESS_ACTIVE" == "1" ]; then
	SEE="echo LAUNCH $SEE"
	LESS="echo LAUNCH $LESS"
	META="echo LAUNCH $META"
	FEH="echo LAUNCH $FEH"
	WORD="echo LAUNCH $WORD"
	EXCEL="echo LAUNCH $EXCEL"
	PDFV="echo LAUNCH $PDFV"
	BROWSER="echo LAUNCH $BROWSER"
fi

if echo $OS | grep -i 'windows' > /dev/null; then
	SEE=start
fi

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] path-to-view...

This will examine something at the specified paths. Directories will be listed. File information will be shown and if possible the file will be viewed somehow.

SEE_AUDIO     Environment variable must be set for an audio file to be played, otherwise only metadata will be shown.
path-to-view  A directory or file to examine.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

Directories will show a directory listing with all file details.

On windows, all other files will simply be viewed using the 'start' command.

Individual compressed files will have their contents shown.

Archive files will be viewed with less so you can inspect the files within them.

Binary files will be dumped in hexadecimal format and any text strings within the file will be displayed.

Media files like sounds, pictures and videos will have their metadata shown so you can see any tagging or comments on them as well as their sizes and resolution.

Picture files will be viewed using the system configured viewer or '$FEH'.

Spreadsheet files will be viewed using the system configured viewer or '$EXCEL'.

Documents will be viewed using the system configured viewer or '$WORD'.

Audio files will only be played if the SEE_AUDIO environment variable is set.  Otherwise only metadata for the audio file will be shown.

See also $META, $BROWSER, $SEE, $LESS, $FEH, $WORD, $EXCEL

Example:

Show current directory listing

 $cmd .

Show metadata and actually play a sound and video file

  SEE_AUDIO=1 $cmd sound.wav video.mov
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
if [ -z "$1" ]; then
	echo You must specify a directory or file name to examine.
	usage 1
fi

function get_ext {
	local file ext
	file="$1"
	ext=$(echo "${file##*.}" | tr '[:upper:]' '[:lower:]')
	echo $ext
}

function get_xml_docid {
	local file type
	file="$1"
	type=`head "$file" | grep -iE 'progid=|DTD DocBook XML' | perl -pne 's{\A.*DTD\s+(DocBook)\s+XML.*\z}{$1}xmsgi; s{\A.+progid="([^"]+)".*\z}{$1}xmsgi; $_ = lc($_)'`
	echo $type
}

function get_xml_doctype {
	local file type
	file="$1"
	type=`get_xml_docid "$file"`
	case $type in
		"docbook" | "word.document")
			type=docx
			;;
		excel.sheet)
			type=xlsx
			;;
		*)
			type=xml
			;;
	esac
	echo $type
}

function see_xml_document {
	local file type ext
	file="$1"
	ext=`get_ext "$file"`
	if [ "$ext" == "xml" ]; then
		ext=`get_xml_doctype "$file"`
		if [ "$ext" == "xml" ]; then
			return 1
		else
			type=`get_xml_docid "$file"`
			echo "XML: $type => $ext"
			see_extension "$file"
			return $?
		fi
	fi
	return 1
}

function see_extension {
	local file ext
	file="$1"
	ext=`get_ext "$file"`
	if [ "$ext" == "xml" ]; then
		ext=`get_xml_doctype "$file"`
	fi

	case $ext in
		# handle .xml formatted word2003 and docbook
		"doc" | "docx" | "dot" | "odt" | "ott" | "fodt" | "uot" | "rtf")
			# Launch libreoffice for specified document file extensions
			$WORD "$file" &
			;;
		"xls" | "xlsx" | "xlt" | "ods" | "ots" | "fods" | "uos" | "dif" | "dbf" | "csv" | "slk")
			# Launch libreoffice for specified spreadsheet file extensions
			$EXCEL "$file" &
			;;
		"html" | "htm" | "xml")
			$BROWSER "$file" &
			;;
#		"pdf")
#			# Launch a PDF viewer for PDF files
#			$PDFV "$file" &
#			;;
		*)
			# Handle other file extensions or provide a default action
			return 1
		;;
	esac
	return 0
}

function see_archive {
	local file mime
	file="$1"
	mime=`file --brief "$file"`

	# less supports archive types: tar, tgz, zip, deb
	if echo $mime | grep 'bzip2 compressed data' > /dev/null; then
		# bzip2 archive-bzip2.txt
		( echo "$file" contents: ; tar tvf "$file" ) | page
		return 0
	fi
	if echo $mime | grep 'XZ compressed data' > /dev/null; then
		# tar cvf archive.tar.xz --xz text.txt
		( echo "$file" contents: ; tar tvf "$file" ) | less
		return 0
	fi
	if echo $mime | grep 'cpio archive' > /dev/null; then
		# echo text.txt | cpio --create > archive.cpio
		( echo "$file" contents: ; cpio --list --quiet --file="$file" ) | less
		return 0
	fi
	if echo $mime | grep 'current ar archive' > /dev/null; then
		# ar r archive.ar text.txt
		( echo "$file" contents: ; ar t "$file" ) | less
		return 0
	fi
	if echo $mime | grep 'tar archive' > /dev/null; then
		# tar cf archive.tar text.txt
		$LESS "$file"
		return 0
	fi
	if echo $mime | grep 'gzip compressed data' > /dev/null; then
		# gz archive-gz.txt
		$LESS "$file"
		return 0
	fi
	if echo $mime | grep 'Zip archive data' > /dev/null; then
		# zip archive.zip text.txt
		$LESS "$file"
		return 0
	fi
	if echo $mime | grep 'Debian binary package' > /dev/null; then
		$LESS "$file"
		return 0
	fi
	return 1
}

function see_binary {
	local file
	file="$1"

	 if perl -e 'exit (-B $ARGV[0] ? 0 : 1 )' "$file"; then
		 ( echo "$file" contents: ; hexdump -C "$file" ; echo "strings:" ; strings "$file" ) | less
		 return 0
	 fi
	 return 1
}

function see_audio {
	local file mime
	file="$1"
	mime=`file --brief "$file"`

	if echo $mime | grep -E 'video|movie|audio|Microsoft ASF|MPEG' > /dev/null; then
		# DONT play sound files, it could be noisy for others, unless
		# ENV var is set SEE_AUDIO=1
		if [ ! -z "$SEE_AUDIO" ]; then
			media "$file"
		else
			$META "$file"
			if [ -z "$AUDIO_WARN" ]; then
				echo WARN: Will not play an audio/video file unless SEE_AUDIO environment variable is set.
				AUDIO_WARN=1
			fi
		fi
		return 0
	fi
	return 1
}

function see_image {
	local file mime
	file="$1"
	mime=`file --brief "$file"`

	# PNG image data
	if echo $mime | egrep 'MS Windows icon resource' > /dev/null; then
		base=`basename "$file"`
		ppm=`mktemp /tmp/$base.XXXXXX.ppm`
		winicontoppm "$file" > $ppm
		media $ppm
		rm $ppm
		return 0
	fi
	if echo $mime | egrep 'pixmap image' > /dev/null; then
		media "$file"
		return 0
	fi
	if echo $mime | egrep 'PC bitmap' > /dev/null; then
		media "$file"
		return 0
	fi
	if echo $mime | egrep 'PostScript' > /dev/null; then
		media "$file"
		return 0
	fi
	if echo $mime | egrep 'PDF document' > /dev/null; then
		media "$file"
		return 0
	fi
	if echo $mime | egrep 'Targa image data' > /dev/null; then
		media "$file" "$FEH"
		return 0
	fi
	if echo $mime | egrep 'image (data|text)' > /dev/null; then
		media "$file"
		return 0
	fi
	if [ "`basename \"$file\"`" == "`basename \"$file\" .xbm`.xbm" ]; then
		media "$file"
		return 0
	fi
	return 1
}

function media {
	local file launch
	file="$1"
	launch=${2:-$SEE}
	$META "$file"
	$SEE "$file"
}

function show {
	local file
	file="$1"

	if [ `wc -l < "$file"` -le $ROWS ]; then
		cat "$file"
	else
		$LESS "$file"
	fi
}

function page {
	local file
	file="$1"

	if [ "$HARNESS_ACTIVE" == "1" ]; then
		echo PIPE less
		cat -
	else
		less
	fi
}

for file in $* ; do
	if [ ! -e "$file" ]; then
		echo "$file" No such file or directory
		exit 1
	else
		if [ ! -d "$file" ]; then
			file "$file"
			md5sum "$file"
			see_audio "$file" || see_xml_document "$file" || see_extension "$file" || see_archive "$file" || see_image "$file" || see_binary "$file" || show "$file"
		else
			echo "$file"
		fi
		ls -al "$file"
	fi
done
