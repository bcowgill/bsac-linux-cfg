#!/bin/bash
# fix directories and filenames with apostrophe in them so they are easier to use with command line scripts
# tar xvzf tests/mv-apostrophe/in/apostrophe-filenames.tgz
# mv-apostrophe.sh --check tests/mv-apostrophe/in
# ASCII apostrophe is converted to Unicode apostrophe ʼ or single quote ’
#	'	U+27	[OtherPunctuation]	APOSTROPHE
#	ʼ	U+2BC	[ModifierLetter]	MODIFIER LETTER APOSTROPHE
#	‘’	‘   ’	‘U+2018 U+2019 LEFT/RIGHT SINGLE QUOTATION MARK [InitialPunctuation] [FinalPunctuation]’

# See also rename-files.sh auto-rename.pl mv-apostrophe.sh mv-spelling.pl mv-to-year.sh mv-camera.sh renumber-by-time.sh renumber-files.sh rename-podcast.sh cp-random.pl

FIND=
if [ "$1" == "--check" ]; then
   FIND=1
   shift
fi
DIR="${1:-.}"

function find_apos {
   find $DIR/ \
   | grep "'" \
   | perl -ne '
      my $q = chr(39); # single quote char
      chomp;
      my $count = $_;
      $count =~ s{[^$q]+}{}xmsg;
      $count = length($count);
      if ($count >= 2)
      {
         print qq{$count: $_\n};
      }
   ' | sort -h
}

function fix {
   local type
   type=$1
   find $DIR/ -type $type \
   | grep "'" \
   | perl -ne '
      my $q = chr(39); # single quote char
      chomp;
      my $new = $_;
      $_ =~ s{$q}{$q\\$q$q}xmsg;
      my $count = $new;
      $count =~ s{[^$q]+}{}xmsg;
      $count = length($count);
      if ($count == 2)
      {
         $new =~ s{$q(.+)$q}{‘$1’}xmsg; # single quote pair
      }
      elsif ($count > 0)
      {
         $new =~ s{$q}{ʼ}xmsg; # use single apostrophe for all
      }
      my $cmd = qq{mv $q$_$q $q$new$q\n};
      print $cmd;
      system $cmd;
   '
}

if [ ! -z "$FIND" ]; then
   find_apos
else
   echo Fix directories...
   fix d
   echo Fix files...
   fix f
   echo Check, any remaining files with apostrophe in their name?
   find $DIR/ | grep "'"  # should be none
fi
