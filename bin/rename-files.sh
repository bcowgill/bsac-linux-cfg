#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machin

if [ -z "$2" ]; then
	echo "
$0 match replace [--exec]

--exec   specify to cause the files to be renamed.

Attempts to rename files in the current directory that match the match string.
The new file name will be converted to lower case letters.
Spaces in the file name will be converted to a dash.
Multiple dashes will be converted to a single one.
By default it only shows how the files would be renamed but doesn\'t do it.

See also ls-spacefiles.sh auto-rename.pl mv-apostrophe.sh mv-spelling.pl mv-to-year.sh mv-camera.sh renumber-by-time.sh renumber-files.sh rename-podcast.sh cp-random.pl

Example:
$0 imag photos-today-

Renames IMAG0000.AVI to photos-today-0000.avi

Puts track/chapter number from file at start:

ls -1 | perl -pne 'chomp; m{(\d\d)}; \$_ = qq{mv \$_ \$1-\$_\n}; system \$_'
"
	exit 0
fi

export MATCH="$1"
export REPLACE="$2"
export EXEC="$3"
ls -1 | perl -MFile::Copy -ne '
	chomp;
	$from = $_;
	$to = lc($from);
	$to =~ s{$ENV{MATCH}}{$ENV{REPLACE}}i;
	$to =~ s{\s+}{-}g;
	$to =~ s{-+}{-}g;
	$to =~ s{\.jpeg\z}{.jpg}xmsi;
	if ($from ne $to) {
		++$moved;
		print qq{mv "$from" "$to"\n};
		if ( -e $to )
		{
			print STDERR qq{$to: file already exists, will not overwrite from [$from]\n};
			++$exists;
			--$moved;
		}
		else
		{
			File::Copy::mv($from, $to) if ($ENV{EXEC});
		}
	}
	END {
		$existed = $ENV{EXEC} ? "already existed and were not overwritten" : "would already exist and would not be overwritten";
		$tense = $ENV{EXEC} ? "were" : "would be";
		$suffix = $ENV{EXEC} ? "" : "  Specify --exec to rename them.";
		if ($moved)
		{
			print qq{$moved files $tense renamed.$suffix\n};
		}
		else
		{
			print qq{No files $tense renamed.\n};
		}
		if ($exists)
		{
			print qq{$exists files $existed.\n};
		}
	}
'
