#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# annotate css/less files with a class name to identify the source file.
# useful when CSS is required into an app and gets shoved into a <style> element thereby obscuring where it came from.
# debug-css.sh [remove]
# See also all-debug-css.sh, css-diagnose.sh, debug-css.sh, filter-css-colors.pl, find-css.sh, invert-css-color.pl
# WINDEV tool useful on windows development machine

# CUSTOM settings you may have to change on a new computer

if [ ${1:-add} == remove ]; then
	export MODE=remove
fi

export INDIR=$(basename `pwd`)
FILES=`find */styles -name '*.less' | head -2`

#echo MODE=$MODE
#echo INDIR=$INDIR
#echo $FILES

perl -i.bak -pne '
$quote = chr(34);
$dir = $ENV{INDIR};
$remove = $ENV{MODE} eq "remove";

#print STDERR qq{$dir\n};
#print STDERR qq{remove=$remove\n};

if ($ARGV ne $current) {
	# if first line in a file
	$current = $ARGV;
	$end = "\n\n";
	print STDERR qq{$current\n};
	$end = "" if $_ =~ s{ \.source-file-less \s* \{ .* \} }{}xms;
#	print STDERR qq{[$end]\n};
	if ($remove) {
		if ($end eq "") {
			$remove_blank_line = 1;
			chomp($_);
		}
	}
	else {
		$_ = qq{.source-file-less { content: $quote$dir/$current$quote; }$end$_};
	}
}
else {
	# checking a line in the file
	if ($remove_blank_line) {
		$remove_blank_line = 0;
		$_ = "" if $_ =~ m{\A \s* \z}xms;
	}
}
' $FILES

exit
# Test this script adding and removing debug when already there / not there.
git stash save crap; git stash drop
debug-css.sh remove ; gitdiff
debug-css.sh ; gitdiff
debug-css.sh ; gitdiff
debug-css.sh remove ; gitdiff
