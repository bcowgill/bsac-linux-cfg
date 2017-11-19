#!/bin/bash
# scan a directory tree and save files containing filenames, directory names, extensions, full file paths and full directory paths

DIR=${1:-$HOME}
STORE=${2:-./}

find "$DIR" -type f | OUT="$STORE" perl -ne '
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

