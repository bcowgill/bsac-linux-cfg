#!/usr/bin/env perl
# Use file command to identify if file is a sound file, not just extension.
# locate -i --regex [aeiou] | filter-music | filter-mime-audio.pl
# Use to create a cmus playlist
# locate -i --regex [aeiou] | filter-music | filter-mime-audio.pl > ~/.cmus/all-sounds.pl
my $DEBUG = 0;

while (my $line = <>)
{
	chomp($line);
	my $mime = `file "$line"`;
	my $original = $mime;
	print STDERR $mime if $DEBUG;
	$mime =~ s{\A[^:]+:\s*}{}xms;
	next if $mime =~ m{\A\s*(directory|data|empty)\s*\z}xmsi;
	next if $mime =~ m{\b(executable|relocatable|symbolic\s+link\s+to|(ASCII|Unicode|8859)\s+text)\b}xmsi;
	#print STDERR $original unless $DEBUG;
	print "$line\n";
#   \b(audio|mpeg|midi|stereo|microsoft asf|video)\b
}
