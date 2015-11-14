#!/usr/bin/env perl
# utf8tr.pl
# transliterate text/digits to alternative utf8 alphabets

use strict;
use warnings;
use 5.012; # almost seamless utf
use feature 'unicode_strings'; # redundant with the 5.012 above
use English qw(-no_match_vars);
use charnames qw(:full); # :loose if you perl version supports it

use Data::Dumper;

binmode(STDIN,  ":encoding(utf8)"); # -CI
binmode(STDOUT, ":utf8"); # -CO
binmode(STDERR, ":utf8"); # -CE

sub usage
{
    my ($exit) = @ARG;

    print <<"USAGE";
$0 [--help] [--space] [--show-styles] [--all-styles] [--alphabet] [--random-style] [--words] [--sentences] style ...

Show text using alphabetic unicode characters

--space space out text characters replaced
--alphabet display the alphabet instead of standard input
--show-styles list all supported font styles and exit immediately
--all-styles display output in all font styles and exit immediately
--random-style choose a random font style to use
--words choose new random style for every word
--sentences choose new random style for every sentence
--help shows this help text

eg.

echo Good Morning | $0 --space italic.bold

$0 --help
$0 --show-styles
$0 --alphabet --space
$0 --alphabet gothic
$0 --alphabet --all-styles
echo Hi | $0 --space --all-styles
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
);
my $rhDefaultStyle = $Alphabet{sans}{stroke};

sub main
{
    my $content;
    my %Opts = (
        spaced => 0,
        random => 0
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
    foreach my $key (keys(%$rhStyles))
    {
        next if length($key) == 1 || !ref($rhStyles->{$key});
        if ($rhStyles->{$key}{a})
        {
            push(@AllStyles, join(".", join(".", @$raPath), $key));
            my $regex = makeTranslation($rhStyles->{$key});
            $rhStyles->{$key}{translate} = $regex;

            # convert tr[][] to s{}{} for spacing out wide chars
            $regex =~ s{\A tr\{ (.+?) \} .+ \z }{s{([ $1])}{\$1 }g}xms;
            $regex =~ s{\{\}\z}{s}xms;
            $rhStyles->{$key}{regex} = $regex;
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
    elsif ($arg =~ m{\A --?se}xms) # --sentences
    {
        $rhOpts->{random} = 'sentence';
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
        $content = join("", 'a' .. 'z');
        $content .= uc($content) . join("", '0' .. '9', "\n");
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
}

sub choose
{
    my (@choices) = @ARG;
    my $choice = int(rand() * scalar(@choices));
    return $choices[$choice];
}

sub output
{
    my ($content, $style, $rhOpts) = @ARG;

    $content = getContent($content);

    if (!ref($style))
    {
        my @StylePath = getStylePath($style);
        $style = getMatchingStyle(\@StylePath, \%Alphabet),
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
        if (exists $rhStyles->{normal} && exists $rhStyles->{normal}{translate})
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
        print translate(
            $content,
            $style,
            $rhOpts->{spaced});

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
    my ($string, $rhStyle, $optSpaced) = @ARG;

    local $ARG = $string;
    eval $rhStyle->{regex} if $optSpaced;
    eval $rhStyle->{translate};
    return $ARG;
}

# product tr/// matching string for a style
# $_ =~ tr{a-z}{\x{1d68a}-\x{1d6a3}};
sub makeTranslation
{
    my ($rhStyle) = @ARG;
    my $from = "";
    my $to = "";

    ($from, $to) = getRange($from, $to, 'a', $rhStyle->{a}, 25);
    ($from, $to) = getRange($from, $to, 'A', $rhStyle->{A}, 25);
    ($from, $to) = getRange($from, $to, '0', $rhStyle->{0}, 9);

    return qq{tr{$from}{$to}};
}

# get tr[a-z][A-Z] ranges given start chars and count
sub getRange
{
    my ($from, $to, $char, $utf, $num) = @ARG;

    if ($utf)
    {
        $utf = toUTF8($utf);
        $from .= "$char-" . addChar($char, $num);
        $to   .= "$utf-"  . addChar($utf,  $num);
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
