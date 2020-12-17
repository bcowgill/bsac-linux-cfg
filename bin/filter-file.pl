#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# TODO WIP work in progress more regexes for file types: documents, graphics, source code, etc need to sample file output from windows, mac and linux...
# WINDEV tool useful on windows development machine
use strict;
use warnings;

use FindBin;
use English qw(-no_match_vars);
use File::Spec;
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

sub usage
{
	my ($message) = @ARG;
	print "$message\n\n" if $message;

	print <<"USAGE";
$FindBin::Script [--help|--man|-?] [--raw] [--summary] [--list] [file ...]

Filter the output of the file command to classify files into different types and extensions.

--raw      shows the output of the file command only slightly touched up without classifying it.
--summary  shows only the overall summary of all the file types found for the common directory path.
--list     shows the summary on multiple lines.
--types    shows the list of classification types supported.
--help     shows help for this program.
--man      shows help for this program.
-?         shows help for this program.

By default it will show the file name and the identified types and file extension for each file.  At the end it shows a total count and summary for the minimum common directory found in all the file names.

If the file info contains mime type and encoding (from the file.sh command) it will be used in classifying the files.

If it cannot classify the file it will show the touched up file output for that file to aid in diagnostics.

/tmp/config-err-0GziBQ: empty
/tmp/tmp.Afa9aqmEFJ: .Afa9aqmEFJ, text
13: /:  4 executable,  4 .gz,  3 archive,  3 script,  3 binary,  3 text,  2 unicode,  1 .Afa9aqmEFJ,  1 link,  1 bash,  1 empty,  1 .cache

The exit code will be zero unless some unknown file types were found, then non-zero.

See also file, file.sh, whatsin.sh, ls-types.sh

Example:

	Show a summary of what is in the /tmp directory:

	whatsin.sh --mime /tmp | $FindBin::Script --summary

	Process the test file output from this script:

	cat $FindBin::Script | after.sh \\\\A__DATA__ | $FindBin::Script --raw; echo == \$? ==

USAGE
	exit($message ? 1 : 0);
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage()
}

my $show_info = 0;
my $show_types = 1;
my $show_ext   = 1;
my $show_files = 1;
my $show_unknown = 1;
my $show_list = 0;

my $raTypesRegex = [
	empty => [qr{\Aempty\z}xms,],

	link => [qr{\bsymbolic\s+link\b}xms,],

	text => [qr{\bASCII\s+text\b}xms,],
	long => [qr{\bvery\s+long\s+lines\b}xms,],
	chunktext => [qr{\bwith\s+no\s+line\s+terminators\b}xms,],
	unicode => [qr{\bUnicode\s+text\b}xms,],

	script => [qr{\bshell\s+script\b}xms,],
	bash => [qr{\bBourne-Again\b}xms,],
	html => [qr{\bHTML\s+document\b}xms,],
	xml => [qr{\bXML\s+[\d+\.]+\s+document\b}xms,],
	pascal => [qr{\bPascal\s+source\b}xms,],
	csource => [qr{\bC\s+source\b}xms,],
	cppsource => [qr{\bC\+\+\s+source\b}xms,],

	binary => [qr{\bdynamically\s+linked\b|\bELF\s+\d+-bit\b}xms,],
	data => [qr{\Adata\z}xms,],

	executable => [qr{\bexecutable\b}xms,],
	archive => [qr{\bcompressed\s+data\b}xms,],

	javaobj => [qr{\bJava\s+serialization\s+data\b}xms,],
];

my $where;
my $files = 0;
my $unknown = 0;
my $rhTypes = {};

while (scalar(@ARGV))
{
	my $arg = shift;
	if ($arg eq '--raw') {
		$show_files = 1;
		$show_info = 1;
		$show_types = 0;
		$show_unknown = 1;
		shift;
	}
	elsif ($arg eq '--summary') {
		$show_files = 0;
		$show_info = 0;
		$show_types = 0;
		$show_unknown = 0;
		shift;
	}
	elsif ($arg eq '--list') {
		$show_list = 1;
		shift;
	}
	elsif ($arg eq '--types')
	{
		my @types = @$raTypesRegex;
		my @supported = ();
		while (scalar(@types))
		{
			my $type = shift(@types);
			my $regexes = shift(@types);
			push(@supported, $type);
		}
		print join("\n", sort(@supported), '');
		exit 0;
	}
	else
	{
		usage("Unknown argument $arg");
	}
}

sub get_extension
{
	my ($filename) = @ARG;

	# destructively get extension from filename
	$filename =~ s{\A\.+}{}xmsg;
	my @parts = split(/\./, $filename);
	my $extension = '';
	if (scalar(@parts) >= 3)
	{
		# possibly two extensions
		$extension = $parts[-2] . '.' . $parts[-1];
		$extension = $parts[-1] if $extension =~ m{\A\d}xms;
	}
	elsif (scalar(@parts) >= 2)
	{
		# a single extension
		$extension = $parts[-1];
	}
	return $extension;
}

sub get_types
{
	my ($filename, $info) = @ARG;
	die "OOPS" unless scalar(@$raTypesRegex);
	my @types = @$raTypesRegex;
	my %types = ();
	my $known;
	while (scalar(@types))
	{
		my $type = shift(@types);
		my $regexes = shift(@types);
		foreach my $regex (@{$regexes})
		{
			if ($info =~ $regex)
			{
				$types{$type} = 1;
				$known = 1;
			}
		}
	}

	$types{executable} = 1 if (-x $filename);
	$types{unknown} = 1 unless $known;

	my $extension = get_extension($filename);
	$types{".$extension"} = 1 if $extension && $show_ext;
	#print STDERR qq{.$extension\n} if $extension;

	return \%types;
}

sub get_minimum_common_path
{
	my ($where, $path) = @ARG;
	if ($where && $path)
	{
		# TODO ./  vs / or relative/ isabsolute function to check?
		my ($volume1, $directories1, $file1) = File::Spec->splitpath($where);
		my ($volume2, $directories2, $file2) = File::Spec->splitpath($path);
		my @dirs1 = File::Spec->splitdir($directories1);
		my @dirs2 = File::Spec->splitdir($directories2);
		#print qq{$where, $volume1, dir: @dirs1\n};
		#print qq{$path, $volume2, dir: @dirs2\n};
		my @common = ();
		while (scalar(@dirs1) && scalar(@dirs2))
		{
			my $next1 = shift(@dirs1);
			my $next2 = shift(@dirs2);
			if ($next1 eq $next2)
			{
				push(@common, $next1);
			}
			else
			{
				last;
			}
		}
		$where = File::Spec->catpath($volume1, File::Spec->catdir(@common), 'XXX');
		#print qq{where=$where\n};
	}
	else
	{
		$where ||= $path;
	}
	return $where;
}

while (my $line = <>) {
	chomp($line);
	if ($line =~ s{\A ([^:]+?) : \s+ (.+) \z}{}xms)
	{
		++$files;
		my ($full_filename, $file_info) = ($1, $2);

		my ($volume, $directories, $filename) = File::Spec->splitpath($full_filename);
		my $path = File::Spec->catpath($volume, $directories, 'XXX');
		$where = get_minimum_common_path($where, $path);

		# strip away inconsequential info...
		$file_info =~ s{, \s+ BuildID\[.+?(,|\z)}{,}xms;
		$file_info =~ s{, \s+ last\s+modified:\s+.+?(,|\z)}{,}xms;
		$file_info =~ s{\(URL=<[^>]*>\)}{(URL=<http://www>)}xms;
		$file_info =~ s{\A\s*}{}xms;
		$file_info =~ s{\s*\z}{}xms;

		# handle mime type and optional encoding if present from file.sh
		# classify.sh: text/plain; charset=us-ascii; ASCII text
		my ($mime_type, $charset);
		if ($file_info =~ s{\A\s*([^;]+)\s*;\s+charset=([^;]+);\s*}{}xms)
		{
			($mime_type, $charset) = ($1, $2)
		}
		elsif ($file_info =~ s{\A\s*([^;]+/[^;]+)\s*;\s*}{}xms)
		{
			$mime_type = $1;
		}

		my $rhFileTypes = get_types($filename, $file_info);
		$rhFileTypes->{$mime_type} = 1 if $mime_type;
		$rhFileTypes->{$charset} = 1 if $charset;
		foreach my $key (keys(%$rhFileTypes))
		{
			++$rhTypes->{$key};
		}
		my $types = join(', ', sort(keys(%$rhFileTypes)));
		if ($types eq 'unknown')
		{
			++$unknown;
		}
		$types = $show_types ? $types : '';

		my $extra = $show_info || $types eq 'unknown' ? "\t\t[$file_info]" : '';
		print qq{$full_filename: $types$extra\n} if $show_files;
	}
	else
	{
		if ($show_files && $show_unknown)
		{
			print "??: $line\n";
			++$unknown;
		}
	}
}

my ($volume, $directories, $file) = File::Spec->splitpath($where);
$where = File::Spec->catpath($volume, $directories);

if ($unknown)
{
	$rhTypes->{unknown} = $unknown;
}

my $joiner = $show_list ? "\n   " : ', ';
my $newline = $show_list ? "\n   " : ' ';
my $types = join($joiner, map { qq{ $rhTypes->{$ARG} $ARG} } sort { $rhTypes->{$b} <=> $rhTypes->{$a}} (keys(%$rhTypes)));
print qq{$files: $where:$newline$types\n};
exit($unknown ? 1 : 0);

__END__
__DATA__
/bin/ntfsmove: ELF 64-bit LSB  shared object, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.24, BuildID[sha1]=a16ee68d61b83446cb2f2686b8c57d031d705143, stripped
/bin/kbd_mode: ELF 64-bit LSB  executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.24
/bin/ntfsmove: ELF 64-bit LSB  shared object, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.24
/bin/lesspipe: POSIX shell script, ASCII text executable
/bin/setupcon: POSIX shell script, UTF-8 Unicode text executable
/bin/zegrep: Bourne-Again shell script, ASCII text executable
/usr/share/man/man1/tcsh.1.gz: gzip compressed data, from Unix, max compression
/usr/share/man/man3/XSLoader.3perl.gz: gzip compressed data, from Unix, max compression
/usr/share/man/man3/y0.3.gz: gzip compressed data, was "y0.3", from Unix, last modified: Tue Sep 17 07:27:58 2013, max compression
/usr/share/man/man3/y0f.3.gz: symbolic link to `y0.3.gz'
/tmp/me/.xscreensaver-getimage.cache: UTF-8 Unicode text
/tmp/config-err-0GziBQ: empty
/tmp/tmp.Afa9aqmEFJ: ASCII text
/tmp/whatami: mr mxysptlk
