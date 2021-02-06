#!/usr/bin/env perl

# (id3info TestIdTag3v1.mp3; id3v2 -R TestIdTag3v1.mp3) | filter-id3.pl
# (id3info TestIdTag3v1.mp3; id3v2 -R TestIdTag3v1.mp3) | INLINE=1 filter-id3.pl
# id3v2 -R Immanuel-Kant-* | DEBUG=1 filter-id3.pl | less
# id3v2 -R Immanuel-Kant-* | filter-id3.pl | less

# TODO add manual/usage details
# TODO INLINE var should be command line parames;
# TODO if id3v2 output shows no ID3 tag, use the id3info command to double check for id3v1 info

use strict;
use warnings;

use English qw(-no_match_vars); # https://metacpan.org/pod/perlvar for reference
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

my $DEBUG = $ENV{DEBUG} || 0;
my $V1OUT = 1;
my $V2OUT = 1;

my $INLINE = $ENV{INLINE} || 0;
my $CH = 2;

my $PAREN = '(DESC)'; # A descriptive name for multi-valued frames
my $BRACKET = '[KEY]'; # A 3 Character identity KEY for multi-valued frames
my $VALUE = 'TXT';
my $TEXT = 3; # index of value in @Frame array

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

my %FramesV1 = qw(
	TIT2 song
	TPE1 artist
   TALB album
   TYER year
   TRCK track
   COMM comment
   TCON genre
);

my $ignore_lines = 0;

# Vars for each file
my $filename;
my @Versions;
my @Args;
my @ArgsV1;
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
	@ArgsV1 = ();
}

# Double quote file names which need it so the shell won't get messed up.
sub file_name
{
	my ($filename) = @ARG;

	if ($filename && $filename =~ m{[\s\$\"]})
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

# Shell escape a double quoted string
sub shell_escape_dq
{
	my ($value) = @ARG;
	# Fix up special characters so the shell doesn't get messed up.
	$value =~ s{\$}{\\\$}xmsg;
	$value =~ s{(['`])}{\\$1}xmsg;
	return $value;
}

# Shell escape a single quoted string
sub shell_escape_sq
{
	my ($value) = @ARG;
	# Fix up special characters so the shell doesn't get messed up.
	# "won't"  =>  'won'\''t'
	$value =~ s{'}{'\\''}xmsg;
	return $value;
}

sub add_frame
{
	my ($frame, $value, $raw) = @ARG;
	push(@Args, qq{\t--$frame "$value" \\\n});
	if (exists($FramesV1{$frame}))
	{
		my $add = 1;
		$raw = defined $raw ? $raw : $value;
		if ($frame eq 'TCON')
		{
			# v1 --genre = number not (number)
			if ($raw !~ m{\A\d+\z}xms)
			{
				$raw =~ s{\A\((\d+)\)\z}{$1}xms;
				$add = 0 unless ($raw =~ m{\A\d+\z}xms);
				$value = $raw;
			}
		}
		push(@ArgsV1, qq{\t--$FramesV1{$frame} "$value" \\\n}) if $add;
	}
}

sub store_frame
{
	my ($frame, $value) = @ARG;

	$value = shell_escape_dq($value);
	if ($INLINE)
	{
		add_frame($frame, $value);
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
		add_frame($frame, "\$$name", $value);
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

	$value = '' unless defined $value;
	if ($final)
	{
		chomp($value);
	}
	if ($paren && $bracket)
	{
		# special handling:
		# COMM: (ID3v1 Comment)[XXX]: It'$ about the `ls` ~ money
		# COMM: ()[]: It$ "about" ~ the `ls` money
		if ($paren eq 'ID3v1 Comment' && $bracket eq 'XXX')
		{
			$paren = $bracket = '';
		}

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
			if ($V1OUT)
			{
				print qq{id3tag \\\n};
				print sort(@ArgsV1);
				print qq{\t$filename\n\n};
			}
			if ($V2OUT)
			{
				print qq{id3v2 \\\n};
				print sort(@Args);
				print qq{\t$filename\n\n};
			}
		}
	}
	init_info();
	return file_name($next_file);
}

sub convert1to2
{
	my ($line) = @ARG;

	# Change id3info output to match id3v2 -R output
	# === TRCK (Track number/Position in set): 1
	# === COMM (Comments): (ID3v1 Comment)[XXX]: COMMENTv1
	# USLT: (LABELv2)[eng]: USLT v2 UNSYNCHRONIZED LYRIC/TEXT TRANSCRIPTION
	$line =~ s{\A===\s([A-Z0-9]{4})\s\([^:]+\):\s}{$1: }xmsg;
	return $line;
}

print qq{# See details on meanings of different frame names: https://id3.org/id3v2.3.0#Text_information_frames_-_details\n};
init_info();
while (my $line = <>)
{
	print $line if $DEBUG;
	chomp($line);

	if ($ignore_lines || $line =~ m{\A(Bitrate|Frequency):}xms)
	{
		# ignore id3info MP3 info output
		$ignore_lines -= 1 if $ignore_lines;
	}
	elsif (($line = convert1to2($line)) && $line =~ m{\A\*\*\*\smp3\sinfo})
	{
		# *** mp3 info
		# MPEG1/layer III
		$ignore_lines = 1;
	}
	elsif ($line =~ m{\AFilename:\s(.+)\z}xms
		 || $line =~ m{\A\*\*\*\sTag\sinformation\sfor\s(.+)\z}xms)
	{
		# chomp off the last newline from the previous frame if it exists
		my $file = $1;
		if ($filename ne file_name($file))
		{
			@Frame = handle_frame(@Frame, 'chomp');
			$filename = output_frames($file);
		}
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

__END__
=== id3info TestId3v1.mp3

*** Tag information for TestId3v1.mp3
=== TIT2 (Title/songname/content description): SONGv1
=== TPE1 (Lead performer(s)/Soloist(s)): ARTISTv1
=== TALB (Album/Movie/Show title): ALBUMv1
=== TYER (Year): 2001
=== TRCK (Track number/Position in set): 1
=== COMM (Comments): (ID3v1 Comment)[XXX]: COMMENTv1
NODESC v1
=== TCON (Content type): (101)
*** mp3 info
MPEG1/layer III
Bitrate: 56KBps
Frequency: 32KHz
=== id3v2 --list
id3v1 tag info for TestId3v1.mp3:
Title  : SONGv1                          Artist: ARTISTv1
Album  : ALBUMv1                         Year: 2001, Genre: Speech (101)
Comment: COMMENTv1
NODESC v1             Track: 1
TestId3v1.mp3: No ID3v2 tag
=== id3v2 --list-rfc822
TestId3v1.mp3: No ID3 tag


id3info TestId3Tagv1.mp3 | filter-id3.pl
# See details on meanings of different frame names: https://id3.org/id3v2.3.0#Text_information_frames_-_details
Unknown Format: *** Tag information for TestId3Tagv1.mp3
Unknown Format: === TIT2 (Title/songname/content description): SONGv1
Unknown Format: === TPE1 (Lead performer(s)/Soloist(s)): ARTISTv1
Unknown Format: === TALB (Album/Movie/Show title): ALBUMv1
Unknown Format: === TYER (Year): 2001
Unknown Format: === TRCK (Track number/Position in set): 1
Unknown Format: === COMM (Comments): (ID3v1 Comment)[XXX]: COMMENTv1
Unknown Format: NODESC v1
Unknown Format: === TCON (Content type): (101)
Unknown Format: *** mp3 info
Unknown Format: MPEG1/layer III
Unknown Format: Bitrate: 56KBps
Unknown Format: Frequency: 32KHz
