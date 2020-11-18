#!/bin/bash
# WINDEV tool useful on windows development machin

if [ -z "$2" ]; then
	echo "
$0 match replace [--exec]

--exec   specify to cause the files to be renamed.

Attempts to rename files in the current directory that match the match string.
The new file name will be converted to lower case letters.
By default it only shows how the files would be renamed but doesn\'t do it.

See also auto-rename.pl, renumber-files.sh, cp-random.pl

Example:
$0 imag photos-today-

Renames IMAG0000.AVI to photos-today-0000.avi

"
	exit 0
fi

export MATCH="$1"
export REPLACE="$2"
export EXEC="$3"
ls | perl -MFile::Copy -ne '
	chomp;
	$from = $_;
	$to = lc($from);
	$to =~ s{$ENV{MATCH}}{$ENV{REPLACE}}i;
	if ($from ne $to) {
		++$moved;
		print qq{mv "$from" "$to"\n};
		File::Copy::mv($from, $to) if ($ENV{EXEC});
	}
	END {
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
	}
'
