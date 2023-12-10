#!/usr/bin/env perl
# examines id3 tags on files and shows the equivalent id3v2 command.
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

use strict;
use warnings;

use English qw(-no_match_vars); # https://metacpan.org/pod/perlvar for reference
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

use FindBin;
#use Sys::Hostname;
#use File::Spec;
#use File::Copy qw(move);
#use File::Find ();
use File::Slurp qw(:std :edit);

use autodie qw(open); # mkdir rmdir unlink move opendir );
# https://www.perl.com/article/37/2013/8/18/Catch-and-Handle-Signals-in-Perl/
use sigtrap qw(handler signal_handler normal-signals);

print STDERR "MUSTDO this was a work in progress, incomplete\n";

sub usage
{
	my ($msg) = @ARG;
	my $cmd = $FindBin::Script;

	say("$msg\n\n") if $msg;
	say(<<"USAGE");
usage: $cmd [--help|--man|-?] filename...

Examines the id3 tags on files and shows the equivalent id3v2 command to tag them.

Can be used to copy and modify the id3 tags from one media file to others.

filename    files to process.
--help      shows help for this program.
--man       shows help for this program.
-?          shows help for this program.

More details... TODO

See also id3v2-ls.sh, id3v2-track.sh, label-music.sh, label-podcast.sh, id3info, id3v2

Example:

$cmd filename...

USAGE
	exit($msg ? 1: 0);
} # usage()

our $VERSION = 0.1;
our $DEBUG = 1;
our $SKIP = 0;

my $PAD = 3;
my $signal_received = 0;

our $TESTING = 0;
our $TEST_CASES = 10;
# prove command sets HARNESS_ACTIVE in ENV
tests() if ($ENV{HARNESS_ACTIVE} || scalar(@ARGV) && $ARGV[0] eq '--test');

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage();
}

sub check_args
{
	# usage('You must provide a file matching pattern.') unless $pattern;
	# usage('You must provide a destination file name prefix.') unless $prefix;

	# failure("source [$source] must be an existing directory.") unless -d $source;
	# failure("destination [$destination] must be an existing directory.") unless -d $destination;
}

sub main
{
	check_args();
	eval
	{
		while (my $line = <DATA>) {
			say("$line");
		}
	};
	if ($EVAL_ERROR)
	{
		debug("catch from main: $EVAL_ERROR", 1);
		# remove_locks($EVAL_ERROR) unless $signal_received;
		say($EVAL_ERROR);
	}
	elsif (!$signal_received)
	{
		# remove_locks();
	}
} # main()

sub signal_handler
{
	$signal_received = 1;
	# remove_locks();
	die "\n$FindBin::Script terminated by signal";
} # signal_handler()

# pad number with leading zeros
sub pad
{
	my ($number, $width) = @ARG;
	my $padded = ('0' x ($width - length($number))) . $number;
	return $padded;
} # pad()

# make tabs 3 spaces
sub tab
{
	my ($message) = @ARG;
	my $THREE_SPACES = ' ' x 3;
	$message =~ s{\t}{$THREE_SPACES}xmsg;
	return $message;
} # tab()

sub failure
{
	my ($warning) = @ARG;
	die( "ERROR: " . tab($warning) . "\n" );
} # failure()

sub debug
{
	my ( $msg, $level ) = @ARG;
	$level ||= 1;
	my $message;

##	print "debug @{[substr($msg,0,10)]} debug: $DEBUG level: $level\n";
	if ( $DEBUG >= $level )
	{
		$message = tab($msg) . "\n";
		if ($TESTING)
		{
			diag(qq{DEBUG: $message});
		}
		else
		{
			print $message
		}
	}
	return $message
} # debug()

sub warning
{
	my ($warning) = @ARG;
	my $message = "WARN: " . tab($warning) . "\n";
	if ($TESTING)
	{
		diag( $message );
	}
	else
	{
		warn( $message );
	}
	return $message;
} # warning()

sub say
{
	my ($message) = @ARG;
	if ($TESTING)
	{
		diag( $message );
	}
	else
	{
		print $message;
	}
	return $message;
}

main();

#===========================================================================
# unit test functions
#===========================================================================

sub test_say
{
	my ($expect, $message) = @ARG;
	my $result = say($message);
	is($result, $expect, "say: [$message] == [$expect]");
}

sub test_tab
{
	my ($expect, $message) = @ARG;

	my $result = tab($message);
	is($result, $expect, "tab: [$message] == [$expect]");
}

sub test_warning
{
	my ($expect, $message) = @ARG;
	my $result = warning($message);
	is($result, $expect, "warning: [$message] == [$expect]");
}

sub test_debug
{
	my ($expect, $message, $level) = @ARG;
	my $result = debug($message, $level);
	is($result, $expect, "debug: [$message, $level] == [@{[$expect || 'undef']}]");
}

sub test_failure
{
	my ($expect, $message) = @ARG;

	my $result;
	eval {
		failure($message);
	};
	if ($EVAL_ERROR)
	{
		$result = $EVAL_ERROR;
	}
	is($result, $expect, "failure: [$message] == [$expect]");
} # test_failure()

sub test_pad
{
	my ($expect, $message) = @ARG;

	my $result = pad($message, $PAD);
	is($result, $expect, "pad: [$message] == [$expect]");
}

#===========================================================================
# unit test suite helper functions
#===========================================================================

# setup / teardown and other helpers specific to this test suite
# see auto-rename.pl for setup of lock dirs etc.

#===========================================================================
# unit test library functions
#===========================================================================

# see auto-rename.pl for a wide variety of test assertions for files, directories, etc.

#===========================================================================
# unit test suite
#===========================================================================

sub tests
{
	$TESTING = 1;

	eval "use Test::More tests => $TEST_CASES;";
	eval "use Test::Exception;";

	test_say("Hello, there", "Hello, there") unless $SKIP;
	test_tab("         Hello", "\t\t\tHello") unless $SKIP;
	test_warning("WARN: WARNING, OH MY!\n", "WARNING, OH MY!") unless $SKIP;
	test_debug(undef, "DEBUG, OH MY!", 10000) unless $SKIP;
	test_debug("DEBUG, OH MY!\n", "DEBUG, OH MY!", -10000) unless $SKIP;
	test_failure("ERROR: FAILURE, OH MY!\n", "FAILURE, OH MY!") unless $SKIP;
	test_pad("000", "") unless $SKIP;
	test_pad("001", "1") unless $SKIP;
	test_pad("123", "123") unless $SKIP;
	test_pad("1234", "1234") unless $SKIP;
	exit 0;
}

__END__
__DATA__
id3info Sample output

*** Tag information for Immanuel-Kant-Is-Reality-Knowable-The-Problem-Posed-By-David-Hume-by-Leonard-Peikoff.mp3
=== COMM (Comments): (ID3v1 Comment)[XXX]: 1 Immanuel Kant Is Reality K
=== TYER (Year): 2021
=== TRCK (Track number/Position in set): 1
=== TPE1 (Lead performer(s)/Soloist(s)): Leonard Peikoff
=== TALB (Album/Movie/Show title): Leonard Peikoff You Tube
=== TIT2 (Title/songname/content description): Immanuel Kant is Reality Knowable
=== TIT3 (Subtitle/Description refinement): The problem posed by David Hume
=== COMM (Comments): ()[]: Immanuel Kant is Reality Knowable
=== TPUB (Publisher): YouTube
=== TCON (Content type): Speech
=== WOAR (Official artist/performer webpage): https://www.youtube.com/redirect?q=https%3A%2F%2Fari.aynrand.org%2F&v=PzlszMgIE0g&event=video_description&redir_token=QUFFLUhqazRrRnk5dXFHWnlDYkkyaTJncWxTYjQ1bFNVU  https://ari.aynrand.org/
=== WPUB (Official publisher webpage): https://www.youtube.com/watch?v=PzlszMgIE0g
=== WOAR (Official artist/performer webpage): https://ari.aynrand.org/
*** mp3 info
MPEG1/layer III
Bitrate: 128KBps
Frequency: 44KHz

id3info TestId3Empty.mp3

*** Tag information for TestId3Empty.mp3
*** mp3 info
MPEG1/layer III
Bitrate: 128KBps
Frequency: 44KHz

id3v2 --list-rfc822 TestId3Empty.mp3
TestId3Empty.mp3: No ID3 tag

id3v2 --list-rfc822 Sample output

Filename: Immanuel-Kant-Is-Reality-Knowable-The-Problem-Posed-By-David-Hume-by-Leonard-Peikoff.mp3
COMM: (ID3v1 Comment)[XXX]: 1 Immanuel Kant Is Reality K
TYER: 2021
TRCK: 1
TPE1: Leonard Peikoff
TALB: Leonard Peikoff You Tube
TIT2: Immanuel Kant is Reality Knowable
TIT3: The problem posed by David Hume
COMM: ()[]: Immanuel Kant is Reality Knowable
TPUB: YouTube
TCON: Speech (101)
WOAR: https://www.youtube.com/redirect?q=https%3A%2F%2Fari.aynrand.org%2F&v=PzlszMgIE0g&event=video_description&redir_token=QUFFLUhqazRrRnk5dXFHWnlDYkkyaTJncWxTYjQ1bFNVU  https://ari.aynrand.org/
WPUB: https://www.youtube.com/watch?v=PzlszMgIE0g
WOAR: https://ari.aynrand.org/
Immanuel-Kant-Is-Reality-Knowable-The-Problem-Posed-By-David-Hume-by-Leonard-Peikoff.mp3: No ID3v1 tag

id3v2 --list-frames Sample output
    --AENC    Audio encryption
    --APIC    Attached picture
    --COMM    Comments
    --COMR    Commercial frame
    --ENCR    Encryption method registration
    --EQUA    Equalization
    --ETCO    Event timing codes
    --GEOB    General encapsulated object
    --GRID    Group identification registration
    --IPLS    Involved people list
    --LINK    Linked information
    --MCDI    Music CD identifier
    --MLLT    MPEG location lookup table
    --OWNE    Ownership frame
    --PRIV    Private frame
    --PCNT    Play counter
    --POPM    Popularimeter
    --POSS    Position synchronisation frame
    --RBUF    Recommended buffer size
    --RVAD    Relative volume adjustment
    --RVRB    Reverb
    --SYLT    Synchronized lyric/text
    --SYTC    Synchronized tempo codes
    --TALB    Album/Movie/Show title
    --TBPM    BPM (beats per minute)
    --TCOM    Composer
    --TCON    Content type
    --TCOP    Copyright message
    --TDAT    Date
    --TDLY    Playlist delay
    --TENC    Encoded by
    --TEXT    Lyricist/Text writer
    --TFLT    File type
    --TIME    Time
    --TIT1    Content group description
    --TIT2    Title/songname/content description
    --TIT3    Subtitle/Description refinement
    --TKEY    Initial key
    --TLAN    Language(s)
    --TLEN    Length
    --TMED    Media type
    --TOAL    Original album/movie/show title
    --TOFN    Original filename
    --TOLY    Original lyricist(s)/text writer(s)
    --TOPE    Original artist(s)/performer(s)
    --TORY    Original release year
    --TOWN    File owner/licensee
    --TPE1    Lead performer(s)/Soloist(s)
    --TPE2    Band/orchestra/accompaniment
    --TPE3    Conductor/performer refinement
    --TPE4    Interpreted, remixed, or otherwise modified by
    --TPOS    Part of a set
    --TPUB    Publisher
    --TRCK    Track number/Position in set
    --TRDA    Recording dates
    --TRSN    Internet radio station name
    --TRSO    Internet radio station owner
    --TSIZ    Size
    --TSRC    ISRC (international standard recording code)
    --TSSE    Software/Hardware and settings used for encoding
    --TXXX    User defined text information
    --TYER    Year
    --UFID    Unique file identifier
    --USER    Terms of use
    --USLT    Unsynchronized lyric/text transcription
    --WCOM    Commercial information
    --WCOP    Copyright/Legal information
    --WOAF    Official audio file webpage
    --WOAR    Official artist/performer webpage
    --WOAS    Official audio source webpage
    --WORS    Official internet radio station homepage
    --WPAY    Payment
    --WPUB    Official publisher webpage
    --WXXX    User defined URL link

id3v2 --list-genres  Sample output
  0: Blues
  1: Classic Rock
  2: Country
  3: Dance
  4: Disco
  5: Funk
  6: Grunge
  7: Hip-Hop
  8: Jazz
  9: Metal
 10: New Age
 11: Oldies
 12: Other
 13: Pop
 14: R&B
 15: Rap
 16: Reggae
 17: Rock
 18: Techno
 19: Industrial
 20: Alternative
 21: Ska
 22: Death Metal
 23: Pranks
 24: Soundtrack
 25: Euro-Techno
 26: Ambient
 27: Trip-Hop
 28: Vocal
 29: Jazz+Funk
 30: Fusion
 31: Trance
 32: Classical
 33: Instrumental
 34: Acid
 35: House
 36: Game
 37: Sound Clip
 38: Gospel
 39: Noise
 40: AlternRock
 41: Bass
 42: Soul
 43: Punk
 44: Space
 45: Meditative
 46: Instrumental Pop
 47: Instrumental Rock
 48: Ethnic
 49: Gothic
 50: Darkwave
 51: Techno-Industrial
 52: Electronic
 53: Pop-Folk
 54: Eurodance
 55: Dream
 56: Southern Rock
 57: Comedy
 58: Cult
 59: Gangsta
 60: Top 40
 61: Christian Rap
 62: Pop/Funk
 63: Jungle
 64: Native American
 65: Cabaret
 66: New Wave
 67: Psychedelic
 68: Rave
 69: Showtunes
 70: Trailer
 71: Lo-Fi
 72: Tribal
 73: Acid Punk
 74: Acid Jazz
 75: Polka
 76: Retro
 77: Musical
 78: Rock & Roll
 79: Hard Rock
 80: Folk
 81: Folk-Rock
 82: National Folk
 83: Swing
 84: Fast Fusion
 85: Bebob
 86: Latin
 87: Revival
 88: Celtic
 89: Bluegrass
 90: Avantgarde
 91: Gothic Rock
 92: Progressive Rock
 93: Psychedelic Rock
 94: Symphonic Rock
 95: Slow Rock
 96: Big Band
 97: Chorus
 98: Easy Listening
 99: Acoustic
100: Humour
101: Speech
102: Chanson
103: Opera
104: Chamber Music
105: Sonata
106: Symphony
107: Booty Bass
108: Primus
109: Porn Groove
110: Satire
111: Slow Jam
112: Club
113: Tango
114: Samba
115: Folklore
116: Ballad
117: Power Ballad
118: Rhythmic Soul
119: Freestyle
120: Duet
121: Punk Rock
122: Drum Solo
123: A capella
124: Euro-House
125: Dance Hall
126: Goa
127: Drum & Bass
128: Club-House
129: Hardcore
130: Terror
131: Indie
132: Britpop
133: Negerpunk
134: Polsk Punk
135: Beat
136: Christian Gangsta Rap
137: Heavy Metal
138: Black Metal
139: Crossover
140: Contemporary Christian
141: Christian Rock
142: Merengue
143: Salsa
144: Thrash Metal
145: Anime
146: JPop
147: Synthpop
