#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# split long lines at specified column to satisfy linters
# See also split-brace.sh, split-comma.sh, splitdiff, split-jest-snapshot.pl, split-list.pl, split-long.sh, split-semicolon.sh, split-spaces.sh
# WINDEV tool useful on windows development machine

if [ "$1" == "--help" ]; then
	echo "
usage: $(basename $0) file ...

This will wrap lines in files inplace at a specific column width and preserve prefix whitespace on lines..

Environment variables control the line width and comprehensiveness.
LINE_WIDTH defaults to 80.
ALL_LINES  defaults to 0 and only wraps HTML lines with a < ... > on a single line.  Setting it to 1 will wrap all lines in the file at a convenient space.

example:

LINE_WIDTH=100 ALL_LINES=1 $(basename $0) index.html
"
exit
fi

ALL_LINES=$ALL_LINES LINE_WIDTH=$LINE_WIDTH perl -i.bak -pne '
use strict;
use warnings;

my $WIDTH = $ENV{LINE_WIDTH} || 80;
my $ALL = $ENV{ALL_LINES};
my $DEBUG = 0;
my $TEST = 0;

# only process single line HTML elements
if ($ALL || m{\A\s*<.+>\s*\z}xms) {
	$_ = shorten($WIDTH, $_);
}

sub shorten {
	my ($length, $line) = @_;
	eval {
		$line = try_shorten($length, $line);
	};
	if ($@) {
		# nothing to do
	}
	return $line;
}

# assumes no tab characters
sub try_shorten {
	my ($length, $line) = @_;
	$line =~ s{\s*\n}{}xms;
	$line =~ m{\A (\s*)}xms;
	my $prefix = $1;
	print STDERR "line [$line]\n" if $DEBUG;
	print STDERR "prefix [$prefix] @{[length($line)]} $length\n" if $DEBUG;
	if (length($line) >= $length) {
		for (my $idx = $length - 1; $idx >= 0; --$idx) {
			print STDERR "\@$idx @{[substr($line, $idx, 1) ]}\n" if $DEBUG;
			if (substr($line, $idx, 1) eq " ") {
				my $short = substr($line, 0, $idx);
				my $remainder = substr($line, $idx + 1);
				print STDERR "rem: [$remainder]\n" if $DEBUG;
				print STDERR "short: [$short]\n" if $DEBUG;
				if ($short =~ m{\A \s* \z}xms) {
					die "Cannot shorten string";
				}
				$line = "$short\n" . try_shorten($length, "$prefix$remainder");
				last;
			}
		}
	}
	else {
		$line .= "\n";
	}
	print STDERR "out: [$line]\n" if $DEBUG;
	return $line;
}

END {
if ($TEST) {
	my $test_line = qq{     <b> this is some long test string </b>  \n};
	sub ok {
		my ($desc, $expect, $actual) = @_;
		if ($expect eq $actual) {
			print "OK $desc\n";
		}
		else
		{
			$expect =~ s{\n}{[NL]}xmsg;
			$actual =~ s{\n}{[NL]}xmsg;
			print "NOT OK $desc\n\texpected: [$expect]\n\t  actual: [$actual]\n";
		}
	}

	ok("trailing spaces gone", "   this\n", shorten(100, "   this   \n"));
	ok("wrap on space", "   this\n   break\n", shorten(10, "   this break   \n"));

	my $desc = "wrap html too short";
	eval {
		ok($desc, "", try_shorten(10, $test_line));
	};
	if ($@) {
		print "OK $desc throws an error if cannot shorten\n";
	}

	ok("wrap html too short returns original", $test_line, shorten(10, $test_line));
	ok("wrap html big enough", "     <b> this is\n     some long test\n     string </b>\n", shorten(20, $test_line));
}
}
' $*
