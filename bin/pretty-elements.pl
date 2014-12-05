#!/usr/bin/env perl
# space out attributes of long elements so there is one attribute per line where possible
# also put some attributes in a specific order for consistency
# id class name data-bind

# ./pretty-elements.pl tests/pretty-elements/sample-html-elements.txt

use strict;
use warnings;
use English -no_match_vars;
use File::Slurp;
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent = 1;
$Data::Dumper::Terse = 1;

my $DEBUG = 1;

my @AttrOrder = qw(id class name type value method title alt data-bind action);
my @Elements = qw(input textarea select option button div iframe form dl a);
my $elements = join('|', @Elements);

local $INPUT_RECORD_SEPARATOR = undef;
my $q = chr(34).chr(39);  # both types of quotes
my $sol = '[\ \t]*';      # start of line whitespace
my $eol = '[\ \t]*\n';    # whitespace and end of line
my $empty = "";

my $reElement = qr{ ( $sol < ($elements) \s+ (.+?) (/?>) ) }xms;
# handle [% IF tab_selected == 'view_campaign_heatmap' %]class="selected"[% END %] and similar
my $reTTBlock = qr{ ( \[ \% .? \s* IF .+ \% \] ) }xms;
my $reAttrib = qr{ \b ([\w|-]+) \s* = ( \d+ | ([$q]) (.*?) \3 ) }xms;
my $reAttribTrue = qr{ \b ([\w|-]+) \b }xms;

my %IDs = ();

# Remove a constant amount of whitespace indentation from the content
sub unindent
{
	my ($content) = @ARG;
	if ($content =~ m{\A (\s+)}xms)
	{
		print "unindent: [$1]\n" if $DEBUG > 1;
		my $spaces = quotemeta($1);
		$content =~ s{(\A|\n)$spaces}{$1}xmsg;
	}
	return $content;
}

sub get_attributes
{
	my ($attributes, $all) = @ARG;
	my %Attribs = ('__TT_BLOCKS__', []);

	# First pull out any Template toolkit conditions
	$attributes =~ s{ $reTTBlock }{
		my ($condition) = ($1);
		push(@{$Attribs{'__TT_BLOCKS__'}}, $condition);
		$empty;
	}xmsge;

	$attributes =~ s{ $reAttrib }{
		my ($attr, $val) = ($1, $2);
		$val = qq{"$val"} unless $val =~ m{\A[$q]}xms;
		$Attribs{$attr} = qq{$val};
		$empty;
	}xmsge;

	$attributes =~ s{ $reAttribTrue }{
		my ($attr) = ($1);
		$Attribs{$attr} = qq{__TRUE__};
		$empty;
	}xmsge;

	$attributes =~ s{\A \s+ \z}{}xms;
	if ($attributes ne $empty)
	{
		warn("WARN: leftovers in element: [$attributes]\n   [$all]");
		$Attribs{'__LEFTOVERS__'} = $attributes;
	}
	return \%Attribs;
}

sub format_element
{
	my () = @ARG
}

sub register_id
{
	my ($all, $id, $rhAttribs) = @ARG;
	$rhAttribs->{'id'} = $id;
	if (exists($IDs{$id}))
	{
		warn("\nWARN: duplicate id seen [$id]\n   [$all]\n   [$IDs{$id}[0]]\n");
	}
	push(@{$IDs{$id}}, $all);
}

# If id/name missing for an input, add it
# print a warning for mismatched id/name (unless a radio button)
sub handle_id_name
{
	my ($all, $element, $rhAttribs) = @ARG;
	if ($element eq "input")
	{
		my $mismatch = 0;
		if (exists($rhAttribs->{'id'}))
		{
			register_id($all, $rhAttribs->{'id'}, $rhAttribs);
			if (!exists($rhAttribs->{'name'}))
			{
				$rhAttribs->{'name'} = $rhAttribs->{'id'};
			}
			if ($rhAttribs->{'id'} ne ($rhAttribs->{'name'} || ""))
			{
				$mismatch = 1;
			}
		}
		elsif (exists($rhAttribs->{'name'}))
		{
			register_id($all, $rhAttribs->{'name'}, $rhAttribs);
		}
		if (exists($rhAttribs->{'type'}) && $rhAttribs->{'type'} eq '"radio"')
		{
			# radio boxes must have different id/name
			$mismatch = 0;
		}
		if ($mismatch)
		{
			warn("\nWARN: id/name mismatch in element: [$element]\n   [$all]");
		}
	}
}

sub handle_element
{
	my ($all, $element, $attribs, $ending) = @ARG;
	my $rhAttribs = get_attributes($attribs, $all);

	handle_id_name($all, $element, $rhAttribs);

	print qq{\n[$all]\n   [$element] [$ending] [$attribs]} if $DEBUG;
	print Dumper($rhAttribs) if $DEBUG;
	return format_element($all, $element, $rhAttribs, $ending);
}

# Get the whole file and walk through the selected element types.
my $content = <>;

print "reElement: $reElement\n" if $DEBUG;
print "reAttrib: $reAttrib\n" if $DEBUG;

$content =~ s{ $reElement }{
	my ($all, $element, $attribs, $ending) = ($1, $2, $3, $4);
	print(handle_element($all, $element, $attribs, $ending) . "\n");
	"";
}xmsge;

# find some types of tags which might have lots of attributes
# perl -ne 'sub BEGIN { $/ = undef; } s{([\ \t]*<(input|textarea|select|option|button|div|iframe|form|dl|a) \s+ [^>]+ >)}{print qq{$1\n}}xmsge; ' views/*.tt | less
# find anything and print by length of the tag
# perl -ne 'sub BEGIN { $/ = undef; } s{(<[a-zA-Z] [^>]* >)}{my $tag = $1; my $otag = $1; $tag =~ s{(\s)\s*}{\ }xmsg; print qq{@{[length($otag)]} $tag\n}}xmsge; ' views/*.tt | sort -n -r | less

