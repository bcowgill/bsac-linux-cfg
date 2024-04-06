#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machin

# TODO if provide a directory use find $dir to process the files...

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] match replace [--exec]

This will rename files in the current directory only, searching for a match string and replacing with a replace string.  It makes their names easier to use with the shell mouse selection by converting spaces to dashes.

--exec  Specify to cause the files to be renamed.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

It will process any files which match the match string, ignoring case differences.
The match and replace strings can be identical to restrict the rename to files with a common sub-string in them.
The new file name will be converted to lower case letters.
Spaces in the file name will be converted to a dash.
Bracket and other characters < ( [ { , ; : ? \@ ' \" \` £ \$ \% ^ & * _ + = ~ # | ! } ] ) > will be converted to a dash.
Multiple dashes will be converted to a single one.

By default it only shows how the files would be renamed but doesn\'t do it.

See also ls-spacefiles.sh auto-rename.pl mv-apostrophe.sh mv-spelling.pl mv-to-year.sh mv-camera.sh renumber-by-time.sh renumber-files.sh rename-podcast.sh cp-random.pl

Example:

$cmd ' ' -

Renames any files with spaces in them.

$cmd imag photos-today-

Renames IMAG0000.AVI to photos-today-0000.avi

Puts track/chapter number from file at start:

ls -1 | perl -pne 'chomp; m{(\d\d)}; \$_ = qq{mv \$_ \$1-\$_\n}; system \$_'
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
if [ -z "$2" ]; then
	echo "You must provide a replace string to rename files."
	usage 0
fi

# make vars (which may have space in them) available to the perl script easily
export MATCH="$1"
export REPLACE="$2"
export EXEC="$3"
export SPECIAL="$4"
ls -1 | perl -MFile::Spec; -MFile::Copy -ne '
	chomp;
	$from = $_;
	$to = lc($from);
	$to =~ s{$ENV{MATCH}}{$ENV{REPLACE}}i;
	$to =~ s{\s+}{-}g;
	if ($ENV{SPECIAL})
	{
		# See also cp-random.pl
		$to =~ s{[\s:;,\{\}\[\]\(\)<>,\?\@'"£\$\%\^&\*_\+=~\#`\|!]+}{-}xmsg;
	}
	$to =~ s{--+}{-}g;
	$to =~ s{-?\.-?}{.}xmsg;
	$to =~ s{\A-}{}xmsg;
	$to =~ s{-\z}{}xmsg;
	$to =~ s{\.jpeg\z}{.jpg}xmsi;
	if ($from ne $to) {
		++$moved;
		print qq{mv "$from" "$to"\n};
		if ( -e $to )
		{
			my $next = next_file($to);
			print STDERR qq{$to: file already exists, will use next-numbered [$next] from [$from]\n};
			$to = $next;
			++$exists;
			#--$moved;
		}
		File::Copy::mv($from, $to) if ($ENV{EXEC});
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
			print qq{$exists files $existed and next-numbered file names were used instead.\n};
		}
	}
	# answers with the next available numbered file name for an already existing file.
	sub next_file
	{
		my ($full) = @ARG;
		my ($volume, $path, $filename, $file, $ext) = splitparts($full);
		#print qq{$full => [$volume] [$path] [$filename] [$file] [$ext]\n};

		my $number = 0;
		$number = $1 if ($file =~ s{(\d+)\z}{}xms);

		my $next = $full;
		while (-e $next)
		{
			++$number;
			if ($filename eq "")
			{
				my $sep = chop($path);
				$next = File::Spec->catpath($volume, qq{$path$number$sep});
				$path .= $sep;
			}
			else
			{
				$next = File::Spec->catpath($volume, $path, qq{$file$number$ext});
			}
		}
		return $next;
	} # next_file()

	# splits a full file name into volume, directories, filename (including extension), filename (without extension), extension
	sub splitparts
	{
		my ($full) = @ARG;
		my ($volume, $path, $filename) = File::Spec->splitpath($full);
		my $is_dotfile = $filename =~ s{\A\.}{}xms;

		my $file = $filename;
		$file =~ s{(\.[^.]*(\.[^.]*)?)\z}{}xms;
		my $ext = $1 || "";
		$file = '.' . $file if $is_dotfile;
		return ($volume, $path, $filename, $file, $ext);
	} # splitparts()
'
