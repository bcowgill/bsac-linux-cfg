#!/bin/bash
# create every type of archive for something to see what's best

out=$1
shift

function usage {
	cmd=`basename $0`
	echo "$cmd name-sans-extension file-or-dir [...]

create every known type of archive for something
"
	exit 1
}

if [ -z "$out" ]; then
	usage
fi
if [ -z "$1" ]; then
	usage
fi

for ext in tar tgz bz2 xz;
do
	file="$out.$ext"
	echo $file
	tar acf "$file" $*
done

file="$out.zip"
echo $file
zip "$file" $*

file="$out.ar"
echo $file
ar qs "$file" $*

file="$out.cpio"
echo $file
tmplist=.list
rm $tmplist
for add in $*; do
	echo "$add" >> $tmplist
	cpio --create --file="$file" < $tmplist
done

ls -aloS ${out}.*

