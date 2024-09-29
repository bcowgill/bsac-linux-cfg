#!/usr/bin/env perl
# Convert naughty words to alternative spellings to bypass censorship.
# George Carlin's Dirty Words routine
# More ways to describe dirty words than we have dirty words:
# bad, dirty, filthy, foul, vile, vulgar, coarse, in poor taste, unseemly, street talk, gutter talk, locker room language, barracks talk, bawdy, naughty, saucy, raunchy, rude, crude, lewd, lascivious, indecent, profane, obscene, blue, off-color, risque, suggestive, cursing, cussin, swearing.

# cocksucker motherfucker

my $DEBUG = 0;
my $SHUFFLE = 0;
my $LEET = 2;
my $BITS = 3;

sub bylength
{
	return length($b) <=> length($a);
}

# suffixes
# shi(t)ted shi(t)ter shitting
#qr{s|e|es|ed|er|\1ed|\1er|\1ing|ling|sy|sies|\1ies|ola}i
# stemming pulls off the end of the word

# fuck.er pulls off .er optionally but pecker does not ie peck is ok
# cock/suck allows a space dash or nothing
# ? indicates unable to make out word from George Carlin video
# https://www.youtube.com/watch?v=vYXvsQAxEqY 5:45

my $hash = quotemeta('#');
my @BadWords = grep { $_ !~ m{$hash}xms } sort bylength qw(
	shit
	shat
	piss
	fuck
	cunt
	cock/sucker
	mother/fucker
#cock/suck.er
#motherfuck.er
	tit

	fart
	turd
	crap

	asshole
	ballbag
	hardon
	pisshard
	blueball
#taint?
	nookie
	snatch
	box
	pussy
	pecker
	peckerhead
#peckertracks?
	jism
#donackers?
	dork
	poontang
	cornhole
	dingleberry

	ass
	bitch
	damn
	hell
);
my @SplitWords = grep { m{/}xms } @BadWords;

my $bad = join("|", map { my $temp = $_; $temp =~ s{/}{(?:-|\\s*)}xmsg; $temp } @BadWords);
my $reBadWords = qr{\b($bad)\b}xmsi;

my $split1 = join("|", map { my $temp = $_; $temp =~ s{/(.+)\z}{}xms; $temp } @SplitWords);
my $split2 = join("|", map { my $temp = $_; $temp =~ s{\A(.+)/}{}xms; $temp } @SplitWords);
my $reSplitWords = qr{\A($split1)(-|\s*)($split2)\z}xmsi;

my $reMiddle = qr{\A(.)(.{2,})(.)\z}xms;

#	at @
my %Replace = qw{
	A 4 a @
	B 8 b 6
	C ( c <
	E £ e 3
	F PH f ph
	G 6 g 9
	H #
	I 1 i ;
	l |
	O 0
	P ?
	S 5 s $
	T 7
	V \/
	W VV
	Z 2
};

debug("BadWords: ", join(", ", @BadWords));
debug("\nbad: $bad");
debug("\nreBadWords: $reBadWords");
debug("\n\nSplitWords: ", join(", ", @SplitWords));
debug("split1: $split1");
debug("split2: $split2");
debug("\nreSplitWords: $reSplitWords");

sub debug
{
	print(join("", @_) . "\n") if ($DEBUG);
}

# options to clean the words:
# 1. Keep first and last letters the same but rearrange the order of the middle letters, the mind can still read that easily.
# 2. Replacements: randomly f to ph for example cock$ucker etc using alternative letters or even alphabets, like greek. Don't do every character just a few.

while (my $line = <>)
{
	$line =~ s{$reBadWords}{separate($1)}xmsgie;
	print $line;
}

sub separate
{
	my ($word) = @_;
	debug("Separate: $word");
	if ($word =~ $reSplitWords)
	{
		debug("Separated: $1 [$2] $3");
		return uncensor($1) . $2 . uncensor($3);
	}
	return uncensor($word);
}

sub uncensor
{
	my ($word) = @_;

	debug("Uncensor $word");

	if ($word =~ $reMiddle)
	{
		debug("Middle: $1 $2 $3");
		if ($SHUFFLE)
		{
			return "$1@{[shuffle($2)]}$3";
		}
	}
	return leet($word);
}

sub shuffle
{
	my ($word) = @_;
	debug("Shuffle: $word");
	if (length($word) == 1)
	{
		return replace($word);
	}
	elsif (length($word) == 2)
	{
		my $flipped = substr($word, -1) . substr($word, 0, 1);
		debug("Flipped: $flipped");
		return $flipped;
	}
	my $shuffled = join('',
		map {
			substr($_, -1)
		} sort map {
			"@{[rand()]}$_"
		} split('', $word)
	);
	debug("Shuffled $shuffled");
	return $shuffled;
}

sub replace
{
	my ($letter) = @_;
	my $changed = $Replace{$letter};
	$changed = $letter unless (defined $changed);
	return $changed;
}

sub min
{
	my ($less, $more) = @_;
	return $less < $more ? $less : $more;
}

sub leet
{
	my ($word) = @_;
	my $changed = "";
	debug("Leet: $word");
	my @Indices = sort map { rand() . ':' . $_ } (0 .. length($word));
	my %Change = map {
		my ($rand, $index) = split(':', $Indices[$_]);
		($index, 1)
	} (0 .. min($LEET, length($word) / $BITS));

	foreach my $index (0 .. length($word))
	{
		my $letter = substr($word, $index, 1);
		$changed .= $Change{$index} ? replace($letter) : $letter;
	}
	return $changed;
	# below to replace all possible characters
	#return join('', map { replace($_) } split('', $word));
}
