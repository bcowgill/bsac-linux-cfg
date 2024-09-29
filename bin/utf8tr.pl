#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# utf8tr.pl
# transliterate text/digits to alternative utf8 alphabets
# WINDEV tool useful on windows development machine

use strict;
use warnings;
use 5.012; # almost seamless utf
use feature 'unicode_strings'; # redundant with the 5.012 above
use English qw(-no_match_vars);
use charnames qw(:full); # :loose if you perl version supports it
use FindBin;

use Data::Dumper;

binmode(STDIN,  ":encoding(utf8)"); # -CI
binmode(STDOUT, ":utf8"); # -CO
binmode(STDERR, ":utf8"); # -CE

my @Dipthongs = qw(ae ea ee ia oi ui ch gw ng ph sw th ts);
my $alphabet = join("", 'a' .. 'z') . " " . join(" ", @Dipthongs);
$alphabet .= " " . uc($alphabet) . " " . join("", '0' .. '9', "\n");

sub usage
{
	my ($exit) = @ARG;

	my $cmd = $FindBin::Script;
	print <<"USAGE";
$cmd [--help] [--space] [--alphabet] [--show-styles] [--all-styles] [--flip-case] [--random-style] [--words] [--sentences] style ...

Show text using alphabetic unicode characters

--space        space out text characters replaced
--flip-case    flip upper/lower case
--case-random  randomize upper/lower case for all letters
--case-words   choose random upper/lower case for each word
--random-style choose a random font style to use
--words        choose new random style for every word
--sentences    choose new random style for every sentence
--alphabet     display the alphabet instead of standard input
--map          as --alphabet but display mapping of english alphabet characters.
--show-styles  list all supported font styles and exit immediately
--all-styles   display output in all font styles
--help         shows this help text

See Also anglicise.pl, utf8-ellipsis.pl, utf8-filter.pl, utf8ls-letter.sh, utf8ls-number.sh, utf8ls.pl

eg.

echo Good Morning | $cmd --space italic.bold

$cmd --help
$cmd --show-styles
$cmd --alphabet --space
$cmd --alphabet gothic
$cmd --alphabet --all-styles
$cmd --alphabet --flip-case --all-styles
echo Hi | $cmd --space --all-styles
USAGE

	exit($exit || 0);
}

local $INPUT_RECORD_SEPARATOR = undef;

my @AllStyles;

my %Alphabet = (
	'serif' => {
		'normal' => {
			'a' => '1D68A',
			'A' => '1D670',
			'0' => '1D7F6',
		},
		'italic' => {
			'a' => '1D44E',
			'A' => '1D434',
			'bold' => {
				'a' => '1D482',
				'A' => '1D468',
			},
		},
		'bold' => {
			'a' => '1D41A',
			'A' => '1D400',
			'0' => '1D7CE',
		},
	},
	'sans' => {
		'normal' => {
			'a' => '1D5BA',
			'A' => '1D5A0',
			'0' => '1D7E2',
		},
		'italic' => {
			'a' => '1D622',
			'A' => '1D608',
			'bold' => {
				'a' => '1D656',
				'A' => '1D63C',
			},
		},
		'bold' => {
			'a' => '1D5EE',
			'A' => '1D5D4',
			'0' => '1D7EC',
		},
		'stroke' => {
			'a' => '1D552',
			'A' => '1D538',
			'0' => '1D7D8',
		},
		'full' => {
			'a' => 'FF41',
			'A' => 'FF21',
			'0' => 'FF10',
		},
	},
	'script' => {
		'normal' => {
			'a' => '1D4EA',
			'A' => '1D4D0',
		},
		'italic' => {
			'a' => '1D4B6',
			'A' => '1D49C',
		},
	},
	'gothic' => {
		'normal' => {
			'a' => '1D51E',
			'A' => '1D504',
		},
		'bold' => {
			'a' => '1D586',
			'A' => '1D56C',
		},
	},
	'circled' => {
		'normal' => {
			'a' => '24D0',
			'A' => '24B6',
			'0' => '24EA',
			'1' => '2460',
		},
		'inverse' => {
			'a' => '1F150',
			'A' => '1F150',
			'0' => '24FF',
			'1' => '2776',
		},
	},
	'square' => {
		'normal' => {
			'a' => '1F130',
			'A' => '1F130',
		},
		'dotted' => {
			'a' => '1F1E6',
			'A' => '1F1E6',
		},
		'inverse' => {
			'a' => '1F170',
			'A' => '1F170',
		},
	},
	'parenthesis' => {
		'normal' => {
			'a' => '249C',
			'A' => '1F110',
			'0' => '30', # normal 0
			'1' => '2474',
		},
	},
	'tag' => {
		'normal' => {
			'a' => 'E0061',
			'A' => 'E0041',
			'0' => 'E0030',
		},
	},
	# http://www.mylanguages.org/greek_alphabet.php
	'greek' => {
		'normal' => {
			'a' => '3B1',
			'A' => '391',
			'0' => '30', # normal 0
			'_map' => {
				'A' => '391', # alpha a as in smart
				'a' => '3B1',
				'V' => '392', # beta v as in very
				'v' => '3B2',
				'G' => '393', # gamma between y as in yes and g as in go
				'g' => '3B3',
				'J' => '393', # no letter
				'j' => '3B3',
				'Y' => '393',
				'y' => '3B3',
				'TH' => '394', # delta th as in that
				'Th' => '394',
				'th' => '3B4',
				'E' => '395', # epsilon e as in very
				'e' => '3B5',
				'Z' => '396', # zeta z as in zoo
				'z' => '3B6',
				'EE' => '397', # eta ee as in bee
				'Ee' => '397',
				'ee' => '3B7',
#				'TH' => '398', # theta th as in think
#				'Th' => '398',
#				'th' => '3B8',
#				'EE' => '399', # iota ee as in bee
#				'Ee' => '399',
#				'ee' => '3B9',
				'I' => '399',
				'i' => '3B9',
				'K' => '39A', # kappa k as in look
				'k' => '3BA',
				'Q' => '39A', # no letter
				'q' => '3BA',
				'L' => '39B', # lamda l as in log
				'l' => '3BB',
				'M' => '39C', # mu m as in man
				'm' => '3BC',
				'N' => '39D', # nu n as in not
				'n' => '3BD',
				'X' => '39E', # xi x as in wax
				'x' => '3BE',
				'O' => '39F', # omicron o as in box
				'o' => '3BF',
				'P' => '3A0', # pi p as in top, close to 'b'
				'p' => '3C0',
				'B' => '3A0',
				'b' => '3C0',
				'R' => '3A1', # rho r as in Roma (rolled r)
				'r' => '3C1',
				'S' => '3A3', # sigma s as in sap
				's' => '3C3',
				'C' => '3A3', # or kappa
				'c' => '3C3',
				'T' => '3A4', # tau t as in hot, but softer and close to 'd'
				't' => '3C4',
				'D' => '3A4',
				'd' => '3C4',
#				'EE' => '3A5', # upsilon ee as in bee
#				'Ee' => '3A5',
#				'ee' => '3C5',
				'PH' => '3A6', # phi ph as in photo
				'Ph' => '3A6',
				'ph' => '3C6',
				'F' => '3A6',
				'f' => '3C6',
				'CH' => '3A7', # chi ch as in the scottish loch
				'Ch' => '3A7',
				'ch' => '3C7',
				'PS' => '3A8', # psi ps as in upside
				'Ps' => '3A8',
				'ps' => '3C8',
#				'O' => '3A9', # omega o as in box
#				'o' => '3C9',
				'W' => '3A9', # no letter
				'w' => '3C9',
			}
		},
	},
	# http://www.omniglot.com/writing/ogham.htm
	'ogham' => {
		'normal' => {
			'_case' => 'lc',
			'_preserve' => 's{[<>]}{}xmsg; s{\A}{>}xmsg; s{\z|\n}{<\n}xmsg;      s{[^><\s\.,;:!\?a-z0-9\-+]}{}xmsgi; s{(\d+\.\d*|\.\d+)(e[+-]\d+)?}{}xmsgi; s{[0-9\-+]}{}xmsg; s{[\.,;:!\?]\s*}{<\n>}xmsg; s{\s*<}{<}xmsg; s{<+}{<}xmsg; s{\ \ +}{ }xmsg; s{>\s*<}{\n}xmsg; s{(<\n)([^>])}{$1>$2}xmsg;',
			'a' => '1681',
			'_map' => {
				' ' => '1680',
				#' ' => '2012', # for appearance in console

				'b' => '1681',
				'l' => '1682',
				'f' => '1683',
				'w' => '1683',
				's' => '1684',
				'n' => '1685',

				'h' => '1686',
				'y' => '1686',
				'd' => '1687',
				't' => '1688',
				'c' => '1689',
				'k' => '1689',
				'q' => '168A', # kw
				'm' => '168B',
				'g' => '168C',
				'ng' => '168D',
				'gw' => '168D',
				'sw' => '168E',
				'ts' => '168E',
				'z' => '168E', # sw/ts
				'r' => '168F',

				'a' => '1690',
				'o' => '1691',
				'u' => '1692',
				'e' => '1693',
				'i' => '1694',

				'ea' => '1695',
				'oi' => '1696',
				'ui' => '1697',
				'ia' => '1698',
				'ae' => '1699',

				'p' => '169A',
				'>' => '169B', # start of text
				'<' => '169C', # end of text

				'v' => '1683', # arbitrary not in alphabet
				'x' => '1689', # arbitrary not in alphabet
				'j' => '1694', # arbitrary not in alphabet
			},
		},
	},
	'case' => {
		'normal' => {
			'a' => '61',
			'A' => '41',
		},
		'flip' => {
			'a' => '41',
			'A' => '61',
		},
		'lower' => {
			'a' => '61',
			'A' => '61',
		},
		'upper' => {
			'a' => '41',
			'A' => '41',
		},
		'caps' => {
			'_case' => 'uc',
			'_map' => {
				# ᴀ	U+1D00	[LowercaseLetter]	LATIN LETTER SMALL CAPITAL A
				'A' => '1D00',
				'B' => '299',
				'C' => '1D04',
				'D' => '1D05',
				'E' => '1D07',
				'F' => 'A730',
				'G' => '262',
				'H' => '29C',
				'I' => '26A',
				'J' => '1D0A',
				'K' => '1D0B',
				'L' => '29F',
				'M' => '1D0D',
				'N' => '274',
				'O' => '1D0F',
				'P' => '1D18',
				'Q' => '51', # there is no Q in LATIN LETTER SMALL CAPITAL set
				'R' => '280',
				'S' => 'A731',
				'T' => '1D1B',
				'U' => '1D1C',
				'V' => '1D20',
				'W' => '1D21',
				'X' => '58', # there is no X in LATIN LATTER SMALL CAPITAL
				'Y' => '28F',
				'Z' => '1D22',
				'AE' => '1D01',
				'OE' => '276',
			},
		},
	},
);
my $rhDefaultStyle = $Alphabet{sans}{stroke};

sub main
{
	my $content;
	my %Opts = (
		spaced => 0,
		random => 0,
		case_random => 0,
	);
	my $printed = 0;

	getTranslations(\%Alphabet);
	#print Dumper(\%Alphabet);

	foreach my $arg (@ARGV)
	{
		my $next;

		eval
		{
			($next, $content) = processArg($arg, \%Opts, $content);
			if (!$next) {
				$content = output($content, $arg, \%Opts);
				++$printed;
			}
		};
		if ($EVAL_ERROR)
		{
			warn($EVAL_ERROR);
		}
	}

	$content = output($content, $rhDefaultStyle, \%Opts) unless $printed;
}

# initialize translation strings in Alphabet structure
sub getTranslations
{
	my ($rhStyles, $raPath) = @ARG;

	$raPath = $raPath || [];
	#print("path: " . join(".", @$raPath) . "\n");
	foreach my $key (keys(%$rhStyles))
	{
		#print "check: $key\n";
		next if length($key) == 1 || $key =~ m{^_}xms || !ref($rhStyles->{$key});
		#print "ok: $key\n";
		if ($rhStyles->{$key}{a} || $rhStyles->{$key}{A})
		{
			push(@AllStyles, join(".", join(".", @$raPath), $key));
			my $regex = makeTranslation($rhStyles->{$key});
			$rhStyles->{$key}{translate} = $regex;

			# convert tr[][] to s{}{} for spacing out wide chars
			$regex =~ s{\A tr\{ (.+?) \} .+ \z }{s{([ $1])}{\$1 }g}xms;
			$regex =~ s{\{\}\z}{s}xms;
			$rhStyles->{$key}{regex} = $regex;

			#print "$key a-z\n  trans [$rhStyles->{$key}{translate}]\n  space [$regex]\n\n";# if $regex ne $rhStyles->{$key}{translate};
		}

		if ($rhStyles->{$key}{_map})
		{
			push(@AllStyles, join(".", join(".", @$raPath), $key));
			my ($regex, $spaced) = makeTranslationMap($rhStyles->{$key}{_map});
			$rhStyles->{$key}{translate} = $regex;
			#print "regex: [$regex]\n";

			# convert tr[][] to s{}{} for spacing out wide chars
#			$regex =~ s{\A tr\{ (.+?) \} .+ \z }{s{([ $1])}{\$1 }g}xms;
#			$regex =~ s{\{\}\z}{s}xms;
#			$regex =~ s[\}(\}xmsg)][}---$1]xmsg; # add spacing
			$rhStyles->{$key}{regex} = $spaced;

			#print "$key map\n  trans [$rhStyles->{$key}{translate}]\n  space [$regex]\n\n";# if $regex ne $rhStyles->{$key}{translate};
		}

		# descend a level
		push(@$raPath, $key);
		getTranslations($rhStyles->{$key}, $raPath);
		pop(@$raPath);
	}
}

sub processArg
{
	my ($arg, $rhOpts, $content) = @ARG;

	my $next = 0;
	if ($arg =~ m{\A --?h}xms) # --help
	{
		usage();
	}
	elsif ($arg =~ m{\A --?f}xms) # --flip-case
	{
		$rhOpts->{flip} = 1;
		$next = 1;
	}
	elsif ($arg =~ m{\A --?se}xms) # --sentences
	{
		$rhOpts->{random} = 'sentence';
		$next = 1;
	}
	elsif ($arg =~ m{\A --?case-r}xms) # --case-random
	{
		$rhOpts->{case_random} = 'letter';
		$next = 1;
	}
	elsif ($arg =~ m{\A --?case-w}xms) # --case-words
	{
		$rhOpts->{case_random} = 'word';
		$next = 1;
	}
	elsif ($arg =~ m{\A --?sp}xms) # --space
	{
		$rhOpts->{spaced} = 1;
		$next = 1;
	}
	elsif ($arg =~ m{\A --?sh}xms) # --show-styles
	{
		$content = "";
		print join("\n", @AllStyles, "");
		exit 0;
	}
	elsif ($arg =~ m{\A --?r}xms) # --random-style
	{
		$rhDefaultStyle = choose(@AllStyles);
		$next = 1;
	}
	elsif ($arg =~ m{\A --?w}xms) # --words
	{
		$rhOpts->{random} = 'word';
		$next = 1;
	}
	elsif ($arg =~ m{\A --?alp}xms) # --alphabet
	{
		$content = $alphabet;
		$next = 1;
	}
	elsif ($arg =~ m{\A --?m}xms) # --map
	{
		$rhOpts->{map} = 1;
		$content = $alphabet;
		$next = 1;
	}
	elsif ($arg =~ m{\A --?all}xms) # --all-styles
	{
		foreach my $style (sort(@AllStyles))
		{
			print "$style:\n";
			$content = output($content, $style, $rhOpts);
		}
		exit 0;
	}
	elsif ($arg =~ m{\A -}xms)
	{
		usage(1);
	}
	return ($next, $content);
} # processArg()

sub choose
{
	my (@choices) = @ARG;
	my $choice = int(rand() * scalar(@choices));
	return $choices[$choice];
}

sub output
{
	my ($content, $style, $rhOpts) = @ARG;

	$content = getContent($content) || "";

	if (!ref($style))
	{
		my @StylePath = getStylePath($style);
		$style = getMatchingStyle(\@StylePath, \%Alphabet),
	}

	if ($rhOpts->{case_random})
	{
		$content = flipCaseContent($content, $rhOpts->{case_random});
	}
	my $raContent = [$content];
	if ($rhOpts->{random})
	{
		$raContent = splitContent($content, $rhOpts->{random});
	}
	transform($raContent, $style, $rhOpts);

	return $content;
}

sub getContent
{
	my ($content) = @ARG;

	$content = defined($content) ? $content : <STDIN>;

	return $content;
}

sub getStylePath
{
	my ($style) = @ARG;

	my $topLevel = join("|", keys(%Alphabet));

	# strip non word chars and lowercase
	$style = lc($style);
	$style =~ s{[^a-z]+}{ }xms;

	# correct order of bold and italic
	if ($style =~ m{\b bold \b .+ \b italic \b}xms)
	{
		$style =~ s{\b bold \s*\b}{}xmsg;
		$style =~ s{\b italic \b}{italic bold}xmsg;
	}

	my @StylePath = split(/[^a-z]+/i, $style);

	# assume default style if none given
	if ($style !~ m{\b ($topLevel) \b}xms)
	{
		unshift(@StylePath, 'sans');
	}

	return @StylePath;
}

sub getMatchingStyle
{
	my ($raStyle, $rhStyles) = @ARG;

	#print "in " . join("/", @$raStyle) . "\n";

	my @path;
	while (scalar(@$raStyle))
	{
		my $key = shift(@$raStyle);
		push(@path, $key);
		if (exists $rhStyles->{$key}) {
			#print "into $key\n";
			$rhStyles = $rhStyles->{$key};
		}
		else
		{
			die "not found: " . join('.', @path);
		}
	}
	if (!exists $rhStyles->{translate})
	{
		if (exists $rhStyles->{normal}
			&& exists $rhStyles->{normal}{translate})
		{
			push(@path, 'normal');
			$rhStyles = $rhStyles->{normal};
		}
		else
		{
			die "not found: normal in " . join('.', @path);
		}
	}
	#print join('.', @path) . ": " . Dumper($rhStyles);
	return $rhStyles;
}

sub randomCase
{
	my ($word) = @ARG;
	return rand() < 0.5 ? lc($word) : uc($word);
}

sub flipCaseContent
{
	my ($content, $boundary) = @ARG;
	my $q = "'";
	if ($boundary =~ m{word}i)
	{
		$content =~ s{([-a-z0-9_']+)}{randomCase($1)}xmsige;
	}
	else
	{
		$content =~ s{([a-z])}{randomCase($1)}xmsige;
	}
   return $content;
}

sub splitContent
{
	my ($content, $boundary) = @ARG;
	my @Content = ($content);

	if ($boundary =~ m{word}i)
	{
		my $q = "'";
		@Content = split(m{(\s+)}xms, $content);
	}
	else
	{
		@Content = split(m{(\.\s+|\n\s*\n)}xms, $content);
	}
	#print Dumper(\@Content);
	return \@Content;
}

sub transform
{
	my ($raContent, $style, $rhOpts) = @ARG;
	foreach my $content (@$raContent)
	{
		#print "transform: $content\n";
		if ($rhOpts->{map})
		{
			my $output = $content;
			#print "map: $output\n";
			if ($rhOpts->{spaced})
			{
				#print "map+spaced\n";
				$output =~ s{(\S)}{$1 }xmsg;
			}
			print $output;
		}
		print translate(
			$content,
			$style,
			$rhOpts);

		if ($rhOpts->{random})
		{
			$style = choose(@AllStyles);
			my @StylePath = getStylePath($style);
			$style = getMatchingStyle(\@StylePath, \%Alphabet),
		}
	}
}

sub translate
{
	my ($string, $rhStyle, $rhOpts) = @ARG;

	#print Dumper($rhStyle);
	local $ARG = $string;
	$ARG =~ tr[a-zA-Z][A-Za-z] if $rhOpts->{flip};
	eval "\$ARG = $rhStyle->{_case}(\$ARG)" if ($rhStyle->{_case});
	eval $rhStyle->{_preserve} if $rhStyle->{_preserve};
	#print "spaced: $ARG\n" if $rhOpts->{spaced};
	$ARG =~ s{(\S)\ }{$1  }xmsg if $rhOpts->{spaced};
	#print "spaced2: $ARG [$rhStyle->{regex}]\n" if $rhOpts->{spaced};
	eval $rhStyle->{regex} if $rhOpts->{spaced};
	#print "translate: $ARG [$rhStyle->{translate}]\n";
	eval $rhStyle->{translate};
	return $ARG;
}

# produce tr/// matching string for a style
# $_ =~ tr{a-z}{\x{1d68a}-\x{1d6a3}};
sub makeTranslation
{
	my ($rhStyle) = @ARG;
	my $from = "";
	my $to = "";

	($from, $to) = getRange($from, $to, 'a', $rhStyle->{a}, 25);
	($from, $to) = getRange($from, $to, 'A', $rhStyle->{A}, 25);
	if (exists($rhStyle->{1}))
	{
		($from, $to) = getRange($from, $to, '0', $rhStyle->{0}, 1);
		($from, $to) = getRange($from, $to, '1', $rhStyle->{1}, 8);
	}
	else
	{
		($from, $to) = getRange($from, $to, '0', $rhStyle->{0}, 9);
	}

	my $tr = qq{tr{$from}{$to}};
	#print "tr $tr\n";
	return $tr;
}

# produce tr/// matching string for a mapped style and s{}{} replacer for spacing out the characters
# with individual s{}{} mathcers for dipthongs like ae.
# $_ =~ tr{az}{\x{1d68a}\x{1d6a3}};
# $_ =~ s{ae}{\x{1d68a}}g;s{z}{\x{1d6a3}}g;
sub makeTranslationMap
{
	my ($rhStyleMap) = @ARG;
	my $from = "";
	my $to = "";
	my @replace = ();
	my @space = (); #"s{([a-zA-Z0-9]\ )}{\$1+}xmsg;");

	foreach my $find (sort { length($b) <=> length($a) || $a cmp $b } keys(%$rhStyleMap))
	{
		my $replace = '\x{' . $rhStyleMap->{$find} . '}';
		if (length($find) == 1)
		{
			$from .= $find;
			$to .= $replace;
		}
		else
		{
			push(@replace, "s{$find}{$replace}xmsg;")
		}
		push(@space, "s{$find}{$replace }xmsg;")
	}

	my $tr = qq{tr{$from}{$to}};
	my $search = join(' ', @replace);
	my $spaced = join(' ', @space);
	#print "map s $search\n";
	#print "map tr $tr\n";
	#print "map spaced $spaced\n";
	return ($search . $tr, $spaced);
}

# get tr[a-z][A-Z] ranges given start chars and count
sub getRange
{
	my ($from, $to, $char, $utf, $num) = @ARG;

	if ($utf)
	{
		$utf = toUTF8($utf);
		$from .= $char;
		$to   .= $utf;
		if ($num > 1)
		{
			$from .= "-" . addChar($char, $num);
			$to   .= "-" . addChar($utf,  $num);
		}
	}
	return ($from, $to);
}

# code point to utf8 character
sub toUTF8
{
	my ($hex) = @ARG;
	my $ret = charnames::string_vianame(uc("U+$hex"));
	return $ret;
}

# get char+N code points
sub addChar
{
	my ($char, $num) = @ARG;
	return chr(ord($char) + $num);
}

main();
__END__
