#!/bin/bash
# ( ./utf8-classify-digits.sh | sort | perl -pne 's{\A.+?"}{\t"}xms'; perl -e 'print "\t// group:utf8 code points:number set name:number family name:unicode class // raw characters\n"' ) > utf8-classified-digits.txt

# TODO examine Other Family number sets for similarity in character shapes and group them like Basic and Arabic
# TODO use to make a perl tool which converts all unicode digits into some other number set (0-9 Digits) by default
# TODO use to make a JS library/React tool which lets you type numbers in 0-9 Digits and have them appear in other number sets as you type.

# This script examines unicode digit code points and groups them into character sets so you can transliterate numerals into other number sets.
# It groups the numbers into similar families also so you could use an alternate font for the usual 0-9 characters.
# The output is a set of Javascript strings colon separated with all classifying fields included.

# digit, bullet, partialNN - classifies number sets into the full 0-9 as digit; 1-9 as bullet; and shorter ranges as partial01, partial03 etc...
# Base Family - the numbers that look like 0-9 which were Romanised from the Arabic-indic
# Arabic Family - the Arabic-indic numbers that look like .123407v^9
# Other Family - all other numbers which did not render for me so I couldn't classify them
# ... Family - Smaller or Singular groups of numbers which seemed to be based on the same shapes.

DEBUG=
grep-utf8.sh digit \
	| DEBUG= perl -Mwarnings -MData::Dumper -ne '
BEGIN {
	$DEBUG = $ENV{DEBUG};
	$q = chr(39); # single quote
	%Values = qw(
		ZERO 0
		ONE 1
		TWO 2
		THREE 3
		FOUR 4
		FIVE 5
		SIX 6
		SEVEN 7
		EIGHT 8
		NINE 9
	);
	%Basic = map { ($_, "Base Family") } (
		"0-9",
		"Circled",
		"Comma",
		"Full Stop",
		"Fullwidth",
		"Mathematical",
		"Mathematical Bold",
		"Mathematical Double-struck",
		"Mathematical Monospace",
		"Mathematical Sans-serif",
		"Mathematical Sans-serif Bold",
		"Dingbat Circled Sans-serif",
		"Dingbat Negative Circled",
		"Dingbat Negative Circled Sans-serif",
		"Double Circled",
		"Parenthesized",
		"Negative Circled",
	);
	%Arabic = map { ($_, "Arabic Family") } (
		"Arabic-indic",
		"Extended Arabic-indic",
	);
}

	# 🄀	U+1F100	[OtherNumber]	DIGIT ZERO FULL STOP
	m{\A(.+)\tU\+([0-9A-F]+)\s+\[([^\]]+)\]\s+(.+?)\s*\z}xms;
	my ($char, $code, $class, $description) = ($1, $2, $3, $4);
	my $full_description = $description;

	$code = lc($code);

	my $value;
	$description =~ s{\s*DIGIT\s+([A-Z]+)\s*}{
		$value = $Values{$1} // "";
		" "
	}xmse;
	unless ($value || $value eq 0)
	{
		warn "Digit value not found in: $full_description\t\\u$code\t$char";
		next;
	}
	$description =~ s{\A\s*(.+?)\s*\z}{$1}xms;
	$description = "0-9" if $description =~ m{\A\s*\z}xms;
	$description = join(" ", map { ucfirst(lc($_)) } split(/\s+/, $description));

	print qq{$value\t$q$char$q\t$q\\u$code$q\t$q$class$q\t$q$description$q\n} if $DEBUG;
	$Fonts{$class}{$description}{$value} = {
		value => $value,
		char => $char,
		code => $code,
		class => $class,
		font => $description,
		description => $full_description,
	};
	$Counts{$class}{$description}++;
	print Dumper($Fonts{$class}{$description}{$value}) if $DEBUG;

END {
	foreach my $class (keys(%Counts)) {
		my $rhClass = $Counts{$class};
		foreach my $font (keys(%$rhClass)) {
			my $count = $rhClass->{$font};
			my $group = "partial" . substr("0$count", -2);
			$group = "bullet" if $count >= 9;
			$group = "digit" if $count >= 10;
			$Numbers{$group}{$font} = $Fonts{$class}{$font};
		}
	}
	#print join(", ", keys(%Fonts)) if $DEBUG;
	#print Dumper(\%Counts) if $DEBUG;
	#print Dumper(\%Fonts) if $DEBUG;
	#delete $Numbers{partial};
	#print Dumper(\%Numbers) if $DEBUG;

	foreach my $group (keys(%Numbers)) {
		my $rhFonts = $Numbers{$group};
		foreach my $font (sort(keys(%$rhFonts))) {
			my $rhChars = $rhFonts->{$font};
			my $raw = "";
			my $escaped = "";
			my $class = "xxxx";
			foreach my $digit (0 .. 9) {
				next unless exists($rhChars->{$digit});
				$class = $rhChars->{$digit}{class};
				$raw .= "$rhChars->{$digit}{char} ";
				$escaped .= "\\u$rhChars->{$digit}{code}";
			}
			my $name = "$font " . ucfirst($group . "s");
			$family = $Basic{$font} || $Arabic{$font} || "Other Family";
			$family = "Arabic Family" if $font =~ m{\AArabic\sLetter}xms;
			$family = "Counting Family" if $font =~ m{\ACounting\sRod}xms;
			$family = "$1 Family" if $font =~ m{\A(Ethiopic|Bengali|Oriya|Myanmar|Kayah\sLi|Malayalam|Myanmar\sShan|Nko|Vai|Osmanya|Tamil|Tag)}xms;
			$family = "Indic Family" if $font =~ m{\A((Combining\s)?Devanagaari|Gujarati|Gurmukh|Tibetan)}xms;
			$family = "Khmer-Lao-Thai Family" if $font =~ m{\A(Khmer|Lao|Thai)}xms;
			$family = "Kannada-Telugu" if $font =~ m{\A(Kannada|Telugu)}xms;
			print qq{$group\t$family\t$name\t"$group:$escaped:$name:$family:$class", // $raw\n};
		}
	}
}
'
