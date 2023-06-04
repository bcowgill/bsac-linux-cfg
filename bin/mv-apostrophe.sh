#!/bin/bash
# fix directories and filenames with apostrophe in them so they are easier to use with command line scripts
# ASCII apostrophe is converted to Unicode apostrophe ʼ or single quote ’
#	'	U+27	[OtherPunctuation]	APOSTROPHE
#	ʼ	U+2BC	[ModifierLetter]	MODIFIER LETTER APOSTROPHE
#	‘’	‘   ’	‘U+2018 U+2019 LEFT/RIGHT SINGLE QUOTATION MARK [InitialPunctuation] [FinalPunctuation]’

# See also auto-rename.pl mv-apostrophe.sh mv-spelling.pl mv-to-year.sh mv-camera.sh rename-files.sh renumber-by-time.sh renumber-files.sh rename-podcast.sh cp-random.pl

DIR="$1"

function fix {
   local type
   type=$1
   find $DIR/ -type $type | grep "'" | perl -ne 'my $q = chr(39); chomp; my $new = $_; $_ =~ s{$q}{$q\\$q$q}xmsg; $new =~ s{$q}{ʼ}xmsg; my $cmd = qq{mv $q$_$q $q$new$q\n}; print $cmd; system $cmd;'
}

# TODO fixsq replace pairs of apostrophe with left/right single quote characters


echo Fix directories...
fix d
echo Fix files...
fix f
echo Check, any files with apostrophe in their name?
find $DIR/ | grep "'"  # should be none
