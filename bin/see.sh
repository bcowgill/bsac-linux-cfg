#!/bin/bash
# see info about a file/dir/archive

function see_archive {
	local file
	file="$1"

	if file "$file" | grep 'bzip2 compressed data'; then
		( echo "$file" contents: ; tar tvf "$file" ) | less
		return 0
	fi
	if file "$file" | grep 'XZ compressed data'; then
		( echo "$file" contents: ; tar tvf "$file" ) | less
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
			see_archive "$file" || less "$file"
		else
			echo "$file"
		fi
		ls -al "$file"
	fi
done

