#!/usr/bin/env perl
# split up campaign details template into sub fragments.
# ./split-template.pl views/campaign_details.tt > views/new_campaign_details.tt
# You will have to customise the regex and fragment names to use this.

use strict;
use warnings;
use English;
use File::Slurp;

local $INPUT_RECORD_SEPARATOR = undef;
my $DEBUG = 0;

# Remove a constant amount of whitespace indentation from the content
sub unindent {
	my ($content) = @ARG;
	if ($content =~ m{\A (\s+)}xms)
	{
#		print "unindent: [$1]\n";
		my $spaces = quotemeta($1);
		$content =~ s{(\A|\n)$spaces}{$1}xmsg;
	}
	return $content;
}

# Wrap the template in a START/END comment with the file name
sub wrap {
	my ($file, $content) = @ARG;
	return join("\n", "<!-- START $file -->", unindent($content), "<!-- END $file -->");
}

# Get the whole template and split into header, body, sliver between, script and footer.
my $template = <>;

($template =~ m{
	\A
	(.+?[\ \t]*\n)
	([\ \t]*<dd \s+ class="accordion-navigation \s+ active">.+</dd>[\ \t]*\n)
	(.+?[\ \t]*\n)
	([\ \t]*<script>.+</script>[\ \t]*\n)
	(.*)
	\z}xms);

my ($head, $body, $sliver, $script, $footer) = ($1, $2, $3, $4, $5);

print join("\n", 
	"===== HEAD", $head, 
	"===== BODY", $body, 
	"===== SLIVER", $sliver, 
	"===== SCRIPT", $script, 
	"===== FOOTER", $footer, 
	"===== ") 
	if $DEBUG;

my @Parts = qw(details targeting budget retargeting);
my $new_template = join("",
	$head,
	(map { "[% INCLUDE fragments/campaign_details_$ARG.tt %]\n" } @Parts),
	$sliver,
	"[% INCLUDE fragments/campaign_details_script.tt %]\n",
	$footer
);
print wrap("views/campaign_details.tt", $new_template);
print "=======\n" if $DEBUG;

my $file = "views/fragments/campaign_details_script.tt";
print "$file:\n" . unindent($script) if $DEBUG;
write_file($file, wrap($file, $script));

my $idx = 0;

$body =~ s{([\ \t]*<dd \s+ class="accordion-navigation (?:\s+ active)?">.+?</dd>[\ \t]*\n)}{
	$file = "views/fragments/campaign_details_$Parts[$idx++].tt";
	write_file($file, wrap($file, $1));
	print "=======\n$file:\n" . wrap($file, $1) if $DEBUG;
	"";
}xmsge;

