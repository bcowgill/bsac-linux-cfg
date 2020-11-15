#!/bin/bash
# see info about a file/dir/archive
# linux version below for ref/reuse...

SEE=see
if echo $OS | grep -i 'windows' > /dev/null; then
	SEE=start
fi

function see_archive {
	local file
	file="$1"

	# less supports archive types: tar, tgz, zip, deb
	if file "$file" | grep 'bzip2 compressed data' > /dev/null; then
		( echo "$file" contents: ; tar tvf "$file" ) | less
		return 0
	fi
	if file "$file" | grep 'XZ compressed data'> /dev/null; then
		( echo "$file" contents: ; tar tvf "$file" ) | less
		return 0
	fi
	if file "$file" | grep 'cpio archive'> /dev/null; then
		( echo "$file" contents: ; cpio --list --file="$file" ) | less
		return 0
	fi
	if file "$file" | grep 'current ar archive'> /dev/null; then
		( echo "$file" contents: ; ar t "$file" ) | less
		return 0
	fi
	if file "$file" | grep 'tar archive'> /dev/null; then
		less "$file"
		return 0
	fi
	if file "$file" | grep 'gzip compressed data'> /dev/null; then
		less "$file"
		return 0
	fi
	if file "$file" | grep 'Zip archive data'> /dev/null; then
		less "$file"
		return 0
	fi
	if file "$file" | grep 'Debian binary package'> /dev/null; then
		less "$file"
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

function see_image {
	# PNG image data
	if file "$file" | egrep 'MS Windows icon resource'> /dev/null; then
		$SEE "$file"
#		base=`basename "$file"`
#		ppm=`mktemp /tmp/$base.XXXXXX.ppm`
#		winicontoppm "$file" > $ppm
#		see $ppm
#		rm $ppm
		return 0
	fi
	if file "$file" | egrep 'pixmap image'> /dev/null; then
		$SEE "$file"
		return 0
	fi
	if file "$file" | egrep 'PC bitmap'> /dev/null; then
		$SEE "$file"
		return 0
	fi
	if file "$file" | egrep 'PostScript'> /dev/null; then
		$SEE "$file"
		return 0
	fi
	if file "$file" | egrep 'PDF document'> /dev/null; then
		$SEE "$file"
		return 0
	fi
	if file "$file" | egrep 'Targa image data'> /dev/null; then
		$SEE "$file"
#		feh "$file"
		return 0
	fi
	if file "$file" | egrep 'image (data|text)'> /dev/null; then
		$SEE "$file"
		return 0
	fi
	if [ "`basename $file`" == "`basename $file .xbm`.xbm" ]; then
		start "$file"
#		see "$file"
		return 0
	fi
	return 1
}

for file in $* ; do
	if [ ! -e "$file" ]; then
		echo "$file" No such file or directory
		exit 1
	else
		if [ ! -d "$file" ]; then
			file $file
			md5sum $file
			see_archive "$file" || see_image "$file" || see_binary "$file" || less "$file"
		else
			echo "$file"
		fi
		ls -al "$file"
	fi
done
