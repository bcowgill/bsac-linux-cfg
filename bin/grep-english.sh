#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine
ENGLISH="$HOME/bin/english/*english*.txt"

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] pattern

This will search the english word lists for a matching string.

pattern An egrep search pattern to match against english words.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

It will ignore initially capitalised words during the search.

It searches the word lists present in $ENGLISH

See also lookup-english.sh

Example:

$cmd cei | wc -l

$cmd cie | wc -1

"
	exit $code
}

if [ -z "$1" ]; then
	usage 0
fi
if [ "$1" == "--help" ]; then
	usage 0
fi
if [ "$1" == "--man" ]; then
	usage 0
fi
if [ "$1" == "-?" ]; then
	usage 0
fi

# Search the english word lists, excluding capitalised names.
egrep --no-filename $1 $ENGLISH | egrep -v '^[A-Z]' | filter-newlines.pl | sort | uniq

exit $?

# Find all english words which are palindromes with length two or more.
grep-english.sh '.' | perl -ne 'chomp; $words{$_} = 1; END { foreach my $word (sort(keys(%words))) { $reverse = join("",reverse(split(//, $word))); delete($words{$word}) unless length($word)>1 && $word eq $reverse }; print join("\n",sort(keys(%words)), "") }' > english-palindromes.txt

# Find all english words which when reversed are also english words, but not palindromes themselves.
grep-english.sh '.' | perl -ne 'chomp; $words{$_} = 1; END { foreach my $word (sort(keys(%words))) { $reverse = join("",reverse(split(//, $word))); $ok = $words{$reverse}; $words{$word} = qq{$word $reverse}; delete($words{$word}) unless length($word) > 1 && $word ne $reverse && $ok }; print join("\n",sort(values(%words)), "") }' > english-reversable-words.txt
