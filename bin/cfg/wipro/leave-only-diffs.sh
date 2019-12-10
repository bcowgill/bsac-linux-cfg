#!/bin/bash
# leave only different files in two directories

BR_DIR="$1"
OTHER_DIR="$2"

# Remove identical files and touch a counterpart for new files.
for F in `find $BR_DIR -type f`; do
	O=`perl -e 'my ($file, $dir, $dir2) = @ARGV; $file =~ s{\A$dir}{$dir2}xms; print $file' $F $BR_DIR $OTHER_DIR`
	if [ -e "$O" ]; then
		if diff --brief "$F" "$O" ; then
			rm "$F" "$O"
		fi
	else
		mkdir -p "$O"
		rmdir "$O"
		touch "$O"
	fi
done

# Remove identical files and touch a counterpart for deleted files.
for F in `find $OTHER_DIR -type f`; do
	O=`perl -e 'my ($file, $dir, $dir2) = @ARGV; $file =~ s{\A$dir}{$dir2}xms; print $file' $F $OTHER_DIR $BR_DIR`
	if [ -e "$O" ]; then
		if diff --brief "$F" "$O" ; then
			rm "$F" "$O"
		fi
	else
		mkdir -p "$O"
		rmdir "$O"
		touch "$O"
	fi
done

# Remove all empty directories to simplify things.
find $BR_DIR -type d -depth -exec rmdir {} \;
find $OTHER_DIR -type d -depth -exec rmdir {} \;

echo vdiff $BR_DIR $OTHER_DIR

