#!/bin/bash
# Move git directories with spaces in them to use dashes instead.
# See also mv-apostrophe.sh rename-files.sh git-mv-src.sh

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

./gitmv.sh
