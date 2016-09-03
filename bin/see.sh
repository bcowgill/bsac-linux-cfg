#!/bin/bash
# see info about a file/dir/archive

function see_archive {
	local file
	file="$1"

	# less supports archive types: ar, tar, tgz, zip, deb
	if file "$file" | grep 'bzip2 compressed data'; then
		( echo "$file" contents: ; tar tvf "$file" ) | less
		return 0
	fi
	if file "$file" | grep 'XZ compressed data'; then
		( echo "$file" contents: ; tar tvf "$file" ) | less
		return 0
	fi
	if file "$file" | grep 'cpio archive'; then
		( echo "$file" contents: ; cpio --list --file="$file" ) | less
		return 0
	fi
	if file "$file" | grep 'current ar archive'; then
		less "$file"
		return 0
	fi
	if file "$file" | grep 'tar archive'; then
		less "$file"
		return 0
	fi
	if file "$file" | grep 'gzip compressed data'; then
		less "$file"
		return 0
	fi
	if file "$file" | grep 'Zip archive data'; then
		less "$file"
		return 0
	fi
	if file "$file" | grep 'Debian binary package'; then
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

for file in $* ; do
	if [ ! -e "$file" ]; then
		echo "$file" No such file or directory
		exit 1
	else
		if [ ! -d "$file" ]; then
			file $file
			md5sum $file
			see_archive "$file" || see_binary "$file" || less "$file"
		else
			echo "$file"
		fi
		ls -al "$file"
	fi
done

