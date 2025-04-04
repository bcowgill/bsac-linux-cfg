#!/bin/bash
# Move git directories with spaces in them to use dashes instead.
# See also git-mv-dirs-spaces.sh mv-apostrophe.sh rename-files.sh git-mv-src.sh

# MUSTDO help.sh --add -- see git-mv-dirs-spaces.sh

DIR=${1:-.}

touch gitmv.sh
chmod +x gitmv.sh

find $DIR -depth -type d \
	| grep ' ' \
	| perl -pne  '
	chomp;
	$new = $_;
	$q = chr(39);
	$new =~ tr/ _/-/;
	$new =~ s{-+}{-}xmsg;
	$_ = "git mv $q$_$q $new\n\n";
	' > gitmv.sh

if [ -z "$DRY" ]; then
	echo Dry Run: gitmv.sh generated, examine it and run it to do the rename.
else
	./gitmv.sh
fi
