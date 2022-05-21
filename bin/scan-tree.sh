#!/bin/bash
# scan a directory tree and save files containing filenames, directory names, extensions, full file paths and full directory paths
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine
# See also lokate.sh locate(1) updatedb

# See how long the last scan took to complete
# grep -E '(start|finis):' /tmp/$LOGNAME/crontab-scan-tree.log

# $HOME/bin/scan-tree.sh $HOME $HOME/scan-

# TODO - symlinks indexed to separate file broken/file/dir links-broken.lst links-dirs.lst links-files.lst
# TODO - weird characters in file names separate list weird.lst
# TODO - longest file names / path names list long-filenames.lst long-paths.lst

# On a Mac cron jobs don't have permission to enter directories like Documents so you need to grant cron full disk access.
# Drag /usr/sbin/cron into the Full Disk Access area in System Preferences > Security & Privacy > Privacy tab.
# Do the same for Terminal and iTerm2
# Source: https://twitter.com/DaveWoodX/status/1184235412509941761

# On Linux a user cron job can do it.
# PATH=$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
# * * * * * mkdir -p /tmp/$LOGNAME 2> /dev/null && set > /tmp/$LOGNAME/crontab-set.log 2>&1
# */19 * * * * $HOME/bin/scan-tree.sh $HOME $HOME/scan- > /tmp/$LOGNAME/crontab-scan-tree.log  2>&1

DIR=${1:-$HOME}
STORE=${2:-./}
NICE=${3:-15}

ERRORS="${STORE}errors-find.lst"
LINKS="${STORE}links-"

function split_output {
	local out
	out="$1"
	OUT="$out" perl -ne '
		BEGIN
		{
			my $out = $ENV{OUT};
			open($fhFiles, q{>}, qq{${out}files.lst});
			open($fhFileNames, q{>}, qq{${out}filenames.lst});
			open($fhDirs, q{>}, qq{${out}directories.lst});
			open($fhDirNames, q{>}, qq{${out}dirnames.lst});
			open($fhExts, q{>}, qq{${out}extensions.lst});
			open($fhNameMap, q{>}, qq{${out}filemap.lst});
		}

		s{//+}{/}xmsg;
		print $fhFiles $_;
		chomp;
		my @paths = split(q{/}, $_);
		my $filename = pop(@paths);
		my $pathname = join(q{/}, @paths);
		$filenames{$filename} = 1;
		$dirs{$pathname} = 1;
		foreach my $dirname (@paths)
		{
			next if $dirname eq q{};
			$dirnames{$dirname} = 1;
		}
		$extensions{$1} = 1 if (($filename =~ m{ \. ( (tar\.)? [^\.]+) \z }xms) && $filename ne qq{.$1});
		push(@{$filemap{$filename}}, $pathname);

		END
		{
			my $fh;
			close($fhFiles);

			print $fhFileNames join(qq{\n}, sort(keys(%filenames)));
			close($fhFileNames);

			print $fhDirs join(qq{\n}, sort(keys(%dirs)));
			close($fhDirs);

			print $fhDirNames join(qq{\n}, sort(keys(%dirnames)));
			close($fhDirNames);

			print $fhExts join(qq{\n}, sort(keys(%extensions)));
			close($fhExts);

			sub combine
			{
				my ($filename, $raDirs) = @_;
				return map { qq{$filename: $_} } sort(@$raDirs);
			}
			print $fhNameMap join(qq{\n}, map { combine($_, $filemap{$_}) } sort(keys(%filenames)));
			close($fhNameMap);
		}
	'
}

echo start: `date`
nice -n $NICE find "$DIR/" -type f 2> "$ERRORS" | split_output "$STORE"
perl -pne 's{//+}{/}xmsg' $ERRORS
echo links: `date`
nice -n $NICE find "$DIR/" -type l | split_output "$LINKS"
echo finis: `date`
