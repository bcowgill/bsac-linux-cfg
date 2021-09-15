#!/bin/bash
# convert: a murder of crows
# to:      crows,murder

# Sources for collective nouns lists:
# https://englishstudyhere.com/collective-nouns/english-collective-nouns-list/
# https://www.englishgrammar.org/collective-nouns/
# TODO https://www.adducation.info/mankind-nature-general-knowledge/collective-nouns-for-animals/
# TODO also names for offspring by animal type
perl -i -ne '
	next if m{\A\s*\z}xms;
	$_ = lc($_);
	print;
' english-collective-nouns.txt
perl -pne '
	chomp;
	s{\Aan?\s+}{}xms;
	my ($group, $noun) = split(/\s+of\s+/);
	$_ = "$noun,$group\n";
' english-collective-nouns.txt  | sort | uniq > english-collective-nouns.csv
