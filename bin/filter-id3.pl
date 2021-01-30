#!/usr/bin/env perl

# id3v2 -R Immanuel-Kant-* | DEBUG=1 filter-id3.pl | less
# id3v2 -R Immanuel-Kant-* | filter-id3.pl | less

# TODO add manual/usage details

use strict;
use warnings;

use English qw(-no_match_vars); # https://metacpan.org/pod/perlvar for reference
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

my $DEBUG = $ENV{DEBUG} || 0;

my $INLINE = 0;
my $CH = 2;

my $PAREN = '(DESC)'; # A descriptive name for multi-valued frames
my $BRACKET = '[KEY]'; # A 3 Character identity KEY for multi-valued frames
my $VALUE = 'TXT';
my $TEXT = 3; # index of value in @Frame array

# Vars for each file
my $filename;
my @Versions;
my @Args;
my @Defs;
my %Frames;
my %Errors;
my @Frame;
my %Env;
my %Value;
my %Counter = ();

sub init_info
{
	$filename = '';
	@Versions = ('', 'ID3v1', 'ID3v2');
	%Errors = ();
	%Frames = ();
	@Frame = ();
	@Defs = ();
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

sub store_frame
{
	my ($frame, $value) = @ARG;
	# TODO handle " $ etc in values
	if ($INLINE)
	{
		push(@Args, qq{\t--$frame "$value" \\\n});
	}
	else
	{
		my $name = $frame;
		my $duplicate = 0;
		# Combine env values that are identical...
		if (exists $Value{$value})
		{
			$name = $Value{$value};
			$duplicate = 1;
		}
		if (exists $Env{$name} && ($Env{$name} ne $value))
		{
			++$Counter{$name};
			$name .= "_$Counter{$name}";
		}
		$Env{$name} = $value;
		$Value{$value} = $name;
		push(@Defs, qq{$name="$value"}) unless $duplicate;
		push(@Args, qq{\t--$frame "\$$name" \\\n});
	}
}

# sort the Defs and apply space gaps after sorting...
sub space_defs
{
	my $last_frame = '';
	my ($frame, $pre, $gap);

	my @Spaced = map {
		$frame = substr($ARG, 0, $CH);
		$gap = $ARG =~ m{\n}xms ? "\n" : '';
		$pre = $last_frame eq $frame ? $gap : "\n";
		$last_frame = $frame;
		qq{$pre$ARG$gap\n};
	} sort @Defs;
	return @Spaced
}

# Special Text Fields in id3v2
# ()   TXXX DESC:USER DEFINED TEXT INFORMATION(colons allowed)
# []   USER KEY:TERMS OF USE(colons allowed)
# ()[] COMM DESC:COMMENT:KEY
# ()[] USLT DESC:UNSYNCHRONIZED LYRIC/TEXT TRANSCRIPTION:KEY
# KEY can only be three characters long
# DESC can be longer description and any characters.
sub handle_frame
{
	my ($frame, $paren, $bracket, $value, $final) = @ARG;

	return unless $frame;

	if ($final)
	{
		chomp($value);
	}
	if ($paren && $bracket)
	{
		if (exists $Frames{$frame}{$PAREN}{$paren}{$BRACKET}{$bracket}{$VALUE})
		{
			$Errors{"Duplicate: $frame\($paren\)\[$bracket\]: $Frames{$frame}{$PAREN}{$paren}{$BRACKET}{$bracket}{$VALUE}"} = 1;
			$Errors{"Duplicate: $frame\($paren\)\[$bracket\]: $value"} = 1;
		}
		$Frames{$frame}{$PAREN}{$paren}{$BRACKET}{$bracket}{$VALUE} = $value;
		$paren = $paren ? "$paren:" : '';
		$bracket = $bracket ? ":$bracket" : '';
		$paren = ':' if ($bracket && !$paren);
		store_frame($frame, "$paren$value$bracket");
	}
	elsif ($paren)
	{
		if (exists $Frames{$frame}{$PAREN}{$paren}{$VALUE})
		{
			$Errors{"Duplicate: $frame\($paren\): $Frames{$frame}{$PAREN}{$paren}{$VALUE}"} = 1;
			$Errors{"Duplicate: $frame\($paren\): $value"} = 1;
		}
		$Frames{$frame}{$PAREN}{$paren}{$VALUE} = $value;
		$paren = $paren ? "$paren:" : '';
		store_frame($frame, "$paren$value");
	}
	elsif ($bracket)
	{
		if (exists $Frames{$frame}{$BRACKET}{$bracket}{$VALUE})
		{
			$Errors{"Duplicate: $frame\[$bracket\]: $Frames{$frame}{$BRACKET}{$bracket}{$VALUE}"} = 1;
			$Errors{"Duplicate: $frame\[$bracket\]: $value"} = 1;
		}
		$Frames{$frame}{$BRACKET}{$bracket}{$VALUE} = $value;
		$bracket = $bracket ? "$bracket:" : '';
		store_frame($frame, "$bracket$value");
	}
	else
	{
		if (exists $Frames{$frame}{$VALUE})
		{
			$Errors{"Duplicate: $frame $Frames{$frame}{$VALUE}"} = 1;
			$Errors{"Duplicate: $frame $value"} = 1;
		}
		$Frames{$frame}{$VALUE} = $value;
		store_frame($frame, $value);
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
			print space_defs(@Defs);
			print "\n" unless $INLINE;
			print qq{id3v2 \\\n};
			print sort(@Args);
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
		# TODO chomp off the last newling from the previous frame if it exists
		my $file = $1;
		@Frame = handle_frame(@Frame, 'chomp');
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
