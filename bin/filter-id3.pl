#!/usr/bin/env perl

# id3v2 -R Immanuel-Kant-* | DEBUG=1 filter-id3.pl | less
# id3v2 -R Immanuel-Kant-* | filter-id3.pl | less

use strict;
use warnings;

use English qw(-no_match_vars); # https://metacpan.org/pod/perlvar for reference
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

my $DEBUG = $ENV{DEBUG} || 0;

my $PAREN = '(DESC)'; # A descriptive name for multi-valued frames
my $BRACKET = '[KEY]'; # A 3 Character identity KEY for multi-valued frames
my $VALUE = 'TXT';
my $TEXT = 3; # index of value in @Frame array

# Vars for each file
my $filename;
my @Versions;
my @Args;
my %Frames;
my %Errors;
my @Frame;

sub init_info
{
	$filename = '';
	@Versions = ('', 'ID3v1', 'ID3v2');
	%Errors = ();
	%Frames = ();
	@Frame = ();
	@Args = ();
}

sub file_name
{
	my ($filename) = @ARG;
	# TODO handle $ ' " etc
	if ($filename && $filename =~ m{\s})
	{
		$filename = qq{"$filename"};
	}
	return $filename;
}

sub parse_frame
{
	my ($frame, $value) = @ARG;
	my ($paren, $bracket);
	# FRAM: (...)[...]: value
	if ($value =~ m{\(([^\)]*)\)\[([^\]]*)\]:\s(.*)\z}xms)
	{
		$paren = $1; # allows any length/chars
		$bracket = $2; # allows up to 3 characters
		$value = $3; # no colons allowed in the value
	}
	# FRAM: (...): value
	elsif ($value =~ m{\(([^\)]*)\):\s(.*)\z}xms)
	{
		$paren = $1;
		$value = $2;
	}
	# FRAM: [...]: value
	elsif ($value =~ m{\[([^\]]*)\]:\s(.*)\z}xms)
	{
		$bracket = $1;
		$value = $2;
	}
	return ($frame, $paren, $bracket, $value);
}

# Fields in v2 which are in v1
# === TIT2 (Title/songname/content description): SONG
# === TPE1 (Lead performer(s)/Soloist(s)): ARTIST
# === TALB (Album/Movie/Show title): ALBUM
# === TYER (Year): 2001
# === TRCK (Track number/Position in set): 1
# === COMM (Comments): (ID3v1 Comment)[XXX]: COMMENT
# === TCON (Content type): (101)

# Args for v1 fields
#		--artist ARTIST \ == TPE1
#		--song SONG \ == TIT2
#		--album ALBUM \ == TALB
#		--comment COMMENT \ == COMM
#		--desc DESCRIPTION \ == COMM
#		--genre 101 \ == TCON
#		--year 2001 \  == TYER
#		--track 1/10 \ == TRCK / TPOS
#		--total 10 \ == TPOS

# Special Text Fields in id3v2
# ()   TXXX DESC:USER DEFINED TEXT INFORMATION(colons allowed)
# []   USER KEY:TERMS OF USE(colons allowed)
# ()[] COMM DESC:COMMENT:KEY
# ()[] USLT DESC:UNSYNCHRONIZED LYRIC/TEXT TRANSCRIPTION:KEY
# KEY can only be three characters long
# DESC can be longer description and any characters.
sub handle_frame
{
	my ($frame, $paren, $bracket, $value) = @ARG;

	return unless $frame;

	if ($paren && $bracket)
	{
		if (exists $Frames{$frame}{$PAREN}{$paren}{$BRACKET}{$bracket}{$VALUE})
		{
			$Errors{"Duplicate: $frame\($paren\)\[$bracket\]: $Frames{$frame}{$PAREN}{$paren}{$BRACKET}{$bracket}{$VALUE}"} = 1;
			$Errors{"Duplicate: $frame\($paren\)\[$bracket\]: $value"} = 1;
		}
		$Frames{$frame}{$PAREN}{$paren}{$BRACKET}{$bracket}{$VALUE} = $value;
		# TODO handle " $ etc in values
		$paren = $paren ? "$paren:" : '';
		$bracket = $bracket ? ":$bracket" : '';
		$paren = ':' if ($bracket && !$paren);
		push(@Args, qq{\t--$frame "$paren$value$bracket" \\\n});
	}
	elsif ($paren)
	{
		if (exists $Frames{$frame}{$PAREN}{$paren}{$VALUE})
		{
			$Errors{"Duplicate: $frame\($paren\): $Frames{$frame}{$PAREN}{$paren}{$VALUE}"} = 1;
			$Errors{"Duplicate: $frame\($paren\): $value"} = 1;
		}
		$Frames{$frame}{$PAREN}{$paren}{$VALUE} = $value;
		# TODO handle " $ etc in values
		$paren = $paren ? "$paren:" : '';
		push(@Args, qq{\t--$frame "$paren$value" \\\n});
	}
	elsif ($bracket)
	{
		if (exists $Frames{$frame}{$BRACKET}{$bracket}{$VALUE})
		{
			$Errors{"Duplicate: $frame\[$bracket\]: $Frames{$frame}{$BRACKET}{$bracket}{$VALUE}"} = 1;
			$Errors{"Duplicate: $frame\[$bracket\]: $value"} = 1;
		}
		$Frames{$frame}{$BRACKET}{$bracket}{$VALUE} = $value;
		# TODO handle " $ etc in values
		$bracket = $bracket ? "$bracket:" : '';
		push(@Args, qq{\t--$frame "$bracket$value" \\\n});
	}
	else
	{
		if (exists $Frames{$frame}{$VALUE})
		{
			$Errors{"Duplicate: $frame $Frames{$frame}{$VALUE}"} = 1;
			$Errors{"Duplicate: $frame $value"} = 1;
		}
		$Frames{$frame}{$VALUE} = $value;
		# TODO handle " $ etc in values
		push(@Args, qq{\t--$frame "$value" \\\n});
	}
	return ();
}

sub output_frames
{
	my ($next_file) = @ARG;
	if ($filename)
	{
		if ($DEBUG)
		{
			print qq{$filename\n};
			print "Versions: ", Dumper(\@Versions);
			print "Frames", Dumper(\%Frames);
			print STDERR "Errors: ", Dumper(\%Errors);
		}
		print qq{# $filename }, (join(' ', @Versions) || 'No ID3 tag'), "\n";
		if (scalar(@Args))
		{
			print qq{id3v2 \\\n};
			print @Args;
			print qq{\t$filename\n\n};
		}
	}
	init_info();
	return file_name($next_file);
}

print qq{# See details on meanings of different frame names: https://id3.org/id3v2.3.0#Text_information_frames_-_details\n};
init_info();
while (my $line = <>)
{
	print $line if $DEBUG;
	chomp($line);
	if ($line =~ m{\AFilename:\s(.+)\z}xms)
	{
		my $file = $1;
		@Frame = handle_frame(@Frame);
		$filename = output_frames($file);
	}
	elsif ($line =~ m{\A(.+):\s+No\s+ID3v([12])\s+tag}xms)
	{
		my ($file, $version) = ($1, $2);
		if ($filename eq file_name($file))
		{
			$Versions[$version] = '';
		}
		else
		{
			@Frame = handle_frame(@Frame);
			$filename = output_frames($file);
		}
	}
	elsif ($line =~ m{\A(.+):\s+No\s+ID3\s+tag}xms)
	{
		my $file = $1;
		if ($filename eq file_name($file))
		{
			@Versions = ();
		}
		else
		{
			@Frame = handle_frame(@Frame);
			$filename = output_frames($file);
			@Versions = ();
		}
	}
	elsif ($line =~ m{\A([A-Z1-9]{4}):\s(.+)\z}xms)
	{
		my ($frame, $value) = ($1, $2);
		# handle Unknown (255) with custom text
		# TCON: Something Else (3) (255)
		# becomes --TCON "Something Else (3)"
		# TCON: Salsa (143)
		# becomes --genre 143
		# or --TCON "(143)"
		if ($frame eq 'TCON')
		{
			if (!($value =~ s{\s*\(255\)\s*\z}{}xms))
			{
				if ($value =~ m{(\(\d+\))\s*\z}xms)
				{
					$value = $1;
				}
			}
		}
		@Frame = handle_frame(@Frame);
		@Frame = parse_frame($frame, $value);
	}
	elsif ($line =~ m{\A(\s*)\z}xms)
	{
		if (scalar(@Frame))
		{
			$Frame[$TEXT] .= "\n$1"
		}
	}
	else
	{
		if (scalar(@Frame))
		{
			$Frame[$TEXT] .= "\n$line"
		}
		else
		{
			print STDERR qq{Unknown Format: $line\n};
		}
	}
}
if ($filename)
{
	@Frame = handle_frame(@Frame);
	output_frames();
}
