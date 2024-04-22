#!/bin/bash
#	'	U+27	[OtherPunctuation]	APOSTROPHE
#	ʼ	U+2BC	[ModifierLetter]	MODIFIER LETTER APOSTROPHE
#	‘’	‘   ’	‘U+2018 U+2019 LEFT/RIGHT SINGLE QUOTATION MARK [InitialPunctuation] [FinalPunctuation]’

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "$cmd [--help|--man|-?] [--check|--dry] directory

This will fix directories and filenames with apostrophe and single quotes in them so they are easier to use with command line scripts.

directory  The directory to look in for filenames with apostrophe's in them.  default is the current directory.
--check Check which files and directories would be renamed but don't rename them. It shows a count of the apostrophe's found in the name.
--dry   Same effect as --check.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

File names with ASCII apostrophe is converted to Unicode apostrophe ʼ or single quote ’

See also rename-files.sh auto-rename.pl mv-apostrophe.sh mv-spelling.pl mv-to-year.sh mv-camera.sh renumber-by-time.sh renumber-files.sh rename-podcast.sh cp-random.pl

Example:

	Find all files or directories with an odd number of apostrophe's:

$cmd --check | grep -E '[13579]:'

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

FIND=
if [ "$1" == "--check" -o "$1" == "--dry" ]; then
   FIND=1
   shift
fi
DIR="${1:-.}"

if [ ! -d "$DIR" ]; then
	echo "Unknown parameter $DIR or it's not a valid directory.";
	echo ""
	usage 1
fi

function find_apos {
   find $DIR/ \
   | grep "'" \
   | perl -ne '
      my $q = chr(39); # single quote char
      chomp;
      my $count = $_;
      $count =~ s{[^$q]+}{}xmsg;
      $count = length($count);
      if ($count >= 1)
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
	[ $? == 0 ] && exit 1
	exit 0
fi
