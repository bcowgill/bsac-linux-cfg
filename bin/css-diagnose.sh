#!/bin/bash
# diagnose some webpacked CSS by formatting it nicely and then selectively enableing only specific named CSS style properties.
# See also all-debug-css.sh, css-diagnose.sh, debug-css.sh, filter-css-colors.pl, find-css.sh, invert-css-color.pl
# WINDEV tool useful on windows development machine

CSS="${1:-.}"

FILES=`ls $CSS/*.css`
echo FIX CSS
echo $FILES
perl -i -pne '
	sub allow_rule {
		my ($prop, $value, $semi) = @_;
		my $allow = $prop =~ m{\A\s(margin|padding|border|outline|overflow|background|font|-moz|-webkit)}xms  # begins with
		|| $prop =~ m{\A\s(width|height|color|clear|float|left|right|top|bottom|display|position|cursor|text-decoration|box-sizing|clip|content|text-rendering|text-transform|list-style-type|transition|src)\z}xms # exact match
		|| $prop =~ m{(width|height|align)\z}xms; # ends with
		$Disabled{$prop}++ unless $allow;
		return $allow;
	}

	# protect ; in data: urls
	#s/(url\(data[^;]+) ; ([^\)]+?) (\))/$1<SEMICOLON><DATA>$3/xmsg;
	s/(url\(data[^;]+) ; ([^\)]+?) (\))/$1<SEMICOLON>$2$3/xmsg;

	# standard spacing around { ; }
	s/(;)/$1\n   /xmsg;
	s/(\{)/ $1\n   /xmsg;
	s/(\})/\n$1\n/xmsg;

	# standard spacing around : rules
	s{
		(\s[\-a-z]+) : \s* ([^\{;\n]+) (;?) \n
	}{
		my ($prop, $value, $semi) = ($1, $2, $3);
		allow_rule($prop, $value, $semi)
		? qq{$prop: $value$semi\n}
		: qq{/* $prop: $value$semi */\n} }xmsgie;
	#s{(\s[\-a-z]+) : \s* ([^\{;\n]+) (;?) \n}{\n}xmsgi;

	# restore protected semicolons
	s{<SEMICOLON>}{;}xmsg;

	END {
		my $disabled = join(",", sort(keys(%Disabled)));
		print STDERR qq{CSS properties disabled: $disabled\n};
		use Data::Dumper;
		print STDERR Dumper(\%Disabled);
	}
' $FILES

