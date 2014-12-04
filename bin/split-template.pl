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

my $sol = '[\ \t]*';  # start of line whitespace
my $eol = '[\ \t]*\n';  # whitespace and end of line

# open and close tag to find for splitting template
my $open = '<dd \s+ class="accordion-navigation (?:\s+ active)?">';
my $close = '</dd>';

($template =~ m{
	\A
	(.+? $eol)
	($sol $open .+ $close $eol)
	(.+ $eol)
	($sol <!-- \s+ script \s+ --> .+ </script> $eol)
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

# CUSTOM CHANGES HERE
my $template_file = 'targeting_profile';
my @Parts = qw(visibility schedule country category device location demographics exchange domain);

my $new_template = join("",
	$head,
	(map { "[% INCLUDE fragments/${template_file}_$ARG.tt %]\n" } @Parts),
	$sliver,
	"[% INCLUDE fragments/${template_file}_script.tt %]\n",
	$footer
);
print wrap("views/$template_file.tt", $new_template);
print "=======\n" if $DEBUG;

my $file = "views/fragments/${template_file}_script.tt";
print "$file:\n" . unindent($script) if $DEBUG;
write_file($file, wrap($file, $script));

my $idx = 0;

$body =~ s{($sol $open .+? $close $eol )}{
	$file = "views/fragments/${template_file}_$Parts[$idx++].tt";
	write_file($file, wrap($file, $1));
	print "=======\n$file:\n" . wrap($file, $1) if $DEBUG;
	"";
}xmsge;

