#!/bin/bash
# search and replace some files, slurping the whole thing at once.

WRITE='-i.bak'
WRITE=

touch pause-build.timestamp

perl $WRITE -Mstrict -MEnglish -e '
my $SKIP = 0;
my $DEBUG = 1;

my $sq = chr(39); # single quote
my $dq = chr(34); # double quote
my $obr = "{";

local $INPUT_RECORD_SEPARATOR = undef;

# spit out the file changes with final cleanups
sub spit {
	my ($file) = @ARG;

	# final cleanup here...
	#$file =~ s{(SEARCH)\n(LINE2)}{$2\n$1}xmsg;

	print $file;
}

while (my $file = <>) {
	#print STDERR "[[$file]]";

	print STDERR "Debug info" if $DEBUG;

	# main cleanup here...
	$file =~ s{
		(SEARCH)
		\n (LINE2)
	}{$2\n$1}xmsg;

	spit($file);
}
' $*
