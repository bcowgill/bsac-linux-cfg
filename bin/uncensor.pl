#!/usr/bin/env perl
# echo "You're ugly and AAAAAA your mother dresses you funny" | ./uncensor.pl
# echo "You're ugly and AAAAAA your mother dresses you funny" | perl -pne '$_ = uc($_)' | BITS=1 ./uncensor.pl
# echo Winston Churchill | ALL=1 SHUFFLE=0 uncensor.pl

# Convert naughty words to alternative spellings to bypass censorship.
# George Carlin's Dirty Words routine
# More ways to describe dirty words than we have dirty words:
# bad, dirty, filthy, foul, vile, vulgar, coarse, in poor taste, unseemly, street talk, gutter talk, locker room language, barracks talk, bawdy, naughty, saucy, raunchy, rude, crude, lewd, lascivious, indecent, profane, obscene, blue, off-color, risque, suggestive, cursing, cussin, swearing.

# cocksucker motherfucker
# cock-sucker mother-fucker

use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

my $DEBUG = $ENV{DEBUG} || 0;
my $ALL = $ENV{ALL} || 0;  # change all words (3+ letters long), not just bad words. fraction indicates probability to change any single word.
my $SHUFFLE = $ENV{SHUFFLE} || 0.5; # probability of shuffling a word instead of changing letters
my $CHANGES = $ENV{CHANGES} || 2; # minimum number of letter changes or swaps to try on a word
my $BITS = $ENV{BITS} || 3; # divide word length by this to see how many letter changes or swaps to try
my $TRIES = $ENV{TRIES} || 10; # number of times to try changing a word before giving up

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

# Leet lite substitutions
my %RepLeet = (
	A => [4],
	B => ['8'],
	C => ['<'],
	#D
	E => ['£'],
	F => ['PH'],
	G => ['6'],
	H => ['#'],
	I => ['1'],
	#J
	#K
	#L
	#M
	#N
	O => ['0'],
	P => ['?'],
	#Q
	#R
	S => ['5'],
	T => ['7'],
	#U
	#V => ['\/'],
	#W => ['VV'],
	X => ['%'],
	Y => ['¥'],
	Z => ['2'],

	a => ['@'],
	b => ['6'],
	c => ['¢'],
	#d
	e => ['3'],
	f => ['ph'],
	g => ['9'],
	#h
	i => [':'],
	j => [';'],
	#k
	l => ['|'],
	#m
	n => ['~'],
	o => ['ø'],
	p => ['Þ'],
	#q
	#r
	s => ['$'],
	#t
	#u
	#v
	#w
	x => ['×'],
	#y => ['ÿ'],
	#z
);

# UC leet
# https://i.imgur.com/vImVwZV.png
my %RepUCLeet = (
	A => [4],
	B => ['13'],
	C => ['('],
	D => ['[)'],
	E => ['3'],
	F => ['|='],
	G => ['6'],
	H => ['|-|'],
	I => ['|'],
	J => ['.]'],
	K => ['|<'],
	L => ['1'],
	M => ['|Y|'],
	N => ['/\\/'], # /|/
	O => ['0'],
	P => ['|>'],
	Q => ['O,'],
	R => ['|2'],
	S => ['5'],
	T => ['7'],
	U => ['[_]'],
	V => ['\\/'],
	W => ['\\v/'], # VV
	X => ['}{'],
	Y => ['`/'],
	Z => ['2'],
);

# https://bpb-eu-w2.wpmucdn.com/blogs.lincoln.ac.uk/dist/8/1146/files/2012/05/leet-speak.jpg
my %RepUCLeet2 = (
	A => [4],
	B => ['8'],
	C => ['('],
	D => ['|)'],
	E => ['3'],
	F => ['|='],
	G => ['6'],
	H => ['|-|'],
	I => ['!'],
	J => ['_|'],
	K => ['X'],
	L => ['1'],
	M => ['/\\/\\'],
	N => ['|\\|'],
	O => ['0'],
	P => ['|*'],
	Q => ['O_'],
	R => ['|2'],
	S => ['5'],
	T => ['7'],
	U => ['|_|'],
	V => ['\\/'],
	W => ['\\/\\/'],
	X => ['%'],
	Y => ['j'],
	Z => ['2'],
);

# Replace plain a-z characters with accented characters
my %RepAccented = (
	a => [qw( à á â ã ä å )],
	c => [qw( ç )],
	e => [qw( è é ê ë )],
	i => [qw( ì í î ï )],
	n => [qw( ñ )],
	o => [qw( ò ó ô õ ö )],
	u => [qw( ù ú û ü )],
	y => [qw( ý ÿ )],

	A => [qw( À Á Â Ã Ä Å )],
	C => [qw( Ç )],
	E => [qw( È É Ê Ë )],
	I => [qw( Ì Í Î Ï )],
	N => [qw( Ñ )],
	O => [qw( Ò Ó Ô Õ Ö )],
	U => [qw( Ù Ú Û Ü )],
	Y => [qw( Ý )],
);

# FLAG ALL to show all characters mapped to a letter
# Replace plain a-z characters with look-alike characters in unicode
my %RepLookalike = (
	a => [qw( ａ ⓐ ⒜ а а Ɑ )],
	b => [qw( ｂ ⓑ ⒝ )],
	c => [qw( ｃ ⓒ ⒞ )],
	d => [qw( ｄ ⓓ ⒟ ꝺ )],
	e => [qw( ｅ ⓔ ⒠ )],
	f => [qw( ｆ ⓕ ⒡ )],
	g => [qw( ｇ ⓖ ⒢ )],
	h => [qw( ｈ ⓗ ⒣ )],
	i => [qw( ｉ ⓘ ⒤ )],
	j => [qw( ｊ ⓙ ⒥ )],
	k => [qw( ｋ ⓚ ⒦ )],
	l => [qw( ｌ ⓛ ⒧ )],
	m => [qw( ｍ ⓜ ⒨ )],
	n => [qw( ｎ ⓝ ⒩ )],
	o => [qw( ｏ ⓞ ⒪ о ⲟ ᴑ ο )],
	p => [qw( ｐ ⓟ ⒫ ρ )],
	q => [qw( ｑ ⓠ ⒬ )],
	r => [qw( ｒ ⓡ ⒭ )],
	s => [qw( ｓ ⓢ ⒮ )],
	t => [qw( ｔ ⓣ ⒯ )],
	u => [qw( ｕ ⓤ ⒰ ᴗ )],
	v => [qw( ｖ ⓥ ⒱ )],
	w => [qw( ｗ ⓦ ⒲ )],
	x => [qw( ｘ ⓧ ⒳ )],
	y => [qw( ｙ ⓨ ⒴ )],
	z => [qw( ｚ ⓩ ⒵ ɀ ƶ )],

	A => [qw( Ａ Ⓐ А Α )],
	B => [qw( Ｂ Ⓑ ß β ẞ Β )],
	C => [qw( Ｃ Ⓒ )],
	D => [qw( Ｄ Ⓓ )],
	E => [qw( Ｅ Ⓔ ε ɛ ƹ ꜫ Ɛ Ʃ Ƹ Ꜫ Ε Σ )],
	F => [qw( Ｆ Ⓕ ϝ )],
	G => [qw( Ｇ Ⓖ )],
	H => [qw( Ｈ Ⓗ Η )],
	I => [qw( Ｉ Ⓘ Ι ꞁ )],
	J => [qw( Ｊ Ⓙ ȷ )],
	K => [qw( Ｋ Ⓚ ĸ κ Κ )],
	L => [qw( Ｌ Ⓛ Ⳑ ɩ Ɩ ι )],
	M => [qw( Ｍ Ⓜ ʍ ϻ Μ Ϻ )],
	N => [qw( Ｎ Ⓝ Ν )],
	O => [qw( Ｏ Ⓞ Ⲟ О Ο )],
	P => [qw( Ｐ Ⓟ Ƿ Ρ )],
	Q => [qw( Ｑ Ⓠ )],
	R => [qw( Ｒ Ⓡ )],
	S => [qw( Ｓ Ⓢ ϟ )],
	T => [qw( Ｔ Ⓣ Ƭ τ Ꞇ Ͳ Τ )],
	U => [qw( Ｕ Ⓤ ʊ υ Ʊ )],
	V => [qw( Ｖ Ⓥ ν )],
	W => [qw( Ｗ Ⓦ ω )],
	X => [qw( Ｘ Ⓧ χ Χ )],
	Y => [qw( Ｙ Ⓨ Υ )],
	Z => [qw( Ｚ Ⓩ Ƶ Ζ )],
);

my %RepSubscript = (
	a => [qw( ₐ )],
	e => [qw( ₑ )],
	h => [qw( ₕ )],
	i => [qw( ᵢ )],
	j => [qw( ⱼ )],
	k => [qw( ₖ )],
	l => [qw( ₗ )],
	m => [qw( ₘ )],
	n => [qw( ₙ )],
	o => [qw( ₒ )],
	p => [qw( ₚ )],
	r => [qw( ᵣ ᷊ )],
	s => [qw( ₛ )],
	t => [qw( ₜ )],
	u => [qw( ᵤ )],
	v => [qw( ᵥ )],
	x => [qw( ₓ )],
);

my %RepSuperscript = (
	a => [qw( ͣ )],
	c => [qw( ͨ )],
	d => [qw( ͩ )],
	e => [qw( ͤ )],
	g => [qw( ᷚ )],
	h => [qw( ͪ )],
	i => [qw( ͥ )],
	k => [qw( ᷜ )],
	l => [qw( ᷝ )],
	m => [qw( ͫ )],
	n => [qw( ᷠ ⁿ )],
	o => [qw( ͦ )],
	r => [qw( ͬ )],
	s => [qw( ᷤ )],
	t => [qw( ͭ )],
	u => [qw( ͧ )],
	v => [qw( ͮ )],
	z => [qw( ᷦ )],
);

#my $rhReplace = \%RepLeet;
#my $rhReplace = \%RepUCLeet;
#my $rhReplace = \%RepUCLeet2;
#my $rhReplace = \%RepAccented;
my $rhReplace = \%RepLookalike;
#my $rhReplace = \%RepSubscript;

#combine(\%RepUCLeet);
#combine(\%RepUCLeet2);
#combine(\%RepAccented);
#combine(\%RepSuperscript);

debug("BadWords: ", join(", ", @BadWords));
debug("\nbad: $bad");
debug("\nreBadWords: $reBadWords");
debug("\n\nSplitWords: ", join(", ", @SplitWords));
debug("split1: $split1");
debug("split2: $split2");
debug("\nreSplitWords: $reSplitWords");
debug("\nrhReplace", Dumper($rhReplace));

sub debug
{
	print(join("", @_) . "\n") if ($DEBUG);
}

# options to clean the words:
# 1. Keep first and last letters the same but rearrange the order of the middle letters, the mind can still read that easily.
# 2. Replacements: randomly f to ph for example cock$ucker etc using alternative letters or even alphabets, like greek. Don't do every character just a few.
# 3. Google for a suggested l33t cypter guide.
# https://i.imgur.com/vImVwZV.png
# https://bpb-eu-w2.wpmucdn.com/blogs.lincoln.ac.uk/dist/8/1146/files/2012/05/leet-speak.jpg
# 4. Like 1 but just swap 2-3 adjacent middle letters of the word
# show just the ascii replacement characters
# grep-utf8.sh [A-Z] | grep -aiE 'U\+[0-9a-f][0-9a-f]\s'

while (my $line = <>)
{
	if ($ALL)
	{
		$line =~ s{\b([a-z]{3,})\b}{rand() < $ALL ? uncensor($1) : $1}xmsgie;
	}
	else
	{
		$line =~ s{$reBadWords}{separate($1)}xmsgie;
	}
	print $line;
}

# Combine a set of letter replacements with the current $rhReplace mapping.
sub combine
{
	my ($rhMap) = @_;
	my @Letters = keys(%$rhMap);
	foreach my $letter (@Letters)
	{
		my $raAddTo = $rhReplace->{$letter};
		if ($raAddTo)
		{
			debug("combine $letter [@{[join(' ', @$raAddTo)]}]");
			my $raChanges = $rhMap->{$letter};
			foreach my $change (@$raChanges)
			{
				push($raAddTo, $change) unless grep { $_ eq $change } @$raAddTo;
			}
		}
		else
		{
			my $raCopy = $rhMap->{$letter};
			debug("combine new $letter [@{[join(' ', @$raCopy)]}]");
			$rhReplace->{$letter} = [map { $_ } @{$raCopy}];
		}
	}
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

	my $count = $TRIES;
	debug("Uncensor $word $count");

	my $clean;
	do {
		$clean = clean($word);
		debug("retry $word $count\n") if $count < $TRIES;
	} while (($word eq $clean) && $count--);
	return $clean;
}

sub clean {
	my ($word) = @_;

	debug("Clean $word");

	if ($word =~ $reMiddle)
	{
		debug("Middle: $1 $2 $3");
		if (rand() < $SHUFFLE)
		{
			return "$1@{[shuffle($2)]}$3";
		}
	}
	return leet($word);
}

# Change the middle characters of a word by swapping a few adjacent ones.
sub swap
{
	my ($middle) = @_;
	debug("Swap $middle");
	if (length($middle) == 1)
	{
		return $middle;
	}
	elsif (length($middle) == 2)
	{
		return flip($middle);
	}
	my $swapped = $middle;
	my $changes = how_many($middle);
	while ($changes || $swapped eq $middle)
	{
		my $index = int(rand(length($middle - 1)));
		my $start = $index ? substr($middle, 0, $index) : "";
		my $pair = substr($middle, $index, 2);
		my $end = substr($middle, $index + 2, length($middle) - $index - 2);
		$swapped = $start . flip($pair) . $end;
		debug("Swap#$changes @$index <$start|$pair|$end> $swapped");
		$changes-- unless $swapped eq $middle;
		# MUSTDO finish this
	}
	debug("Swapped $swapped");
	return $swapped;
}

# Flip a pair of characters around
sub flip
{
	my ($pair) = @_;
	die "flip($pair) must be two characters long." unless length($pair) == 2;
	my $flipped = substr($pair, -1) . substr($pair, 0, 1);
	debug("Flipped $flipped");
	return $flipped;
}

# Shuffle the middle characters of a word
sub shuffle
{
	my ($middle) = @_;
	debug("Shuffle: $middle");
	if (length($middle) == 1 )
	{
		return $middle;
	}
	elsif (length($middle) == 2)
	{
		return flip($middle);
	}
	my $shuffled = join('',
		map {
			substr($_, -1)
		} sort map {
			"@{[rand()]}$_"
		} split('', $middle)
	);
	debug("Shuffled $shuffled");
	return $shuffled;
}

# Replace a letter based on configured replacement maps
sub replace
{
	my ($letter) = @_;
	my $changed = pick($letter);
	$changed = $letter unless (defined $changed);
	return $changed;
}

sub pick
{
	my ($letter) = @_;
	my $changed = $letter;
	my $options = $rhReplace->{$letter};
	debug("Pick1($letter) [@{[@$options]}]");
	if (defined $options)
	{
		my $index = int(rand() * scalar(@$options));
		$changed = $options->[$index];
		debug("Pick2($letter) [@{[@$options]}] $index <$changed>");
	}
	return $changed;
}

# return the minimum of two values
sub min
{
	my ($less, $more) = @_;
	return $less < $more ? $less : $more;
}

# return the maximum of two values
sub max
{
	my ($less, $more) = @_;
	return $less > $more ? $less : $more;
}

# return the number of characters to swap or replace based on word length
sub how_many
{
	my ($word) = @_;
	return int(max($CHANGES, length($word) / $BITS));
}

# Replace a few characters of the word based on the configured replacement maps
sub leet
{
	my ($word) = @_;
	my $changed = "";
	debug("Leet: $word");
	my @Indices = sort map { rand() . ':' . $_ } (0 .. length($word));
	my %Change = map {
		my ($rand, $index) = split(':', $Indices[$_]);
		($index, 1)
	} (0 .. how_many($word));

	foreach my $index (0 .. length($word))
	{
		my $letter = substr($word, $index, 1);
		$changed .= $Change{$index} ? replace($letter) : $letter;
	}
	return $changed;
}
