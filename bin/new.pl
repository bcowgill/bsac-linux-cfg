#!/usr/bin/env perl
# tools for creating new files from templates

use strict;
use warnings;
use English qw(-no_match_vars);

use File::Slurp qw(:std :edit);
use autodie qw(open cp);

# show file info and first few lines from file
sub grok_file
{
	my ($file) = @ARG;
	system("ls -al $file");
	system("head $file");
}

sub process_templates
{
	my ($template_dir, $rhTemplates, $rhReplaceWith) = @ARG;

	foreach my $template (sort(keys(%$rhTemplates)))
	{
		my $template_name = "$template_dir/$template";
		my $new_file = $rhTemplates->{$template};
		process_template_file($template_name, $new_file, $rhReplaceWith);
	}
}

sub process_template_file
{
	my ($template_name, $new_file, $rhReplaceWith) = @ARG;

	if (-e $new_file)
	{
		# TODO prompt file already exists
		grok_file($new_file);
		$new_file = undef; # ask to replace file
	}
	if ($new_file)
	{
		# TODO make directory for output file
		my $rContent = read_file( $template, scalar_ref => 1 );
		process_template($rContent, $rhReplaceWith);
		make_file_dir($new_file);
		write_file($new_file, $rContent);
	}
}

sub process_template
{
	my ($rContent, $rhReplaceWith) = @ARG;
	my @keys = sort { length($b) <=> length($a) } keys(%$rhReplaceWith);
	foreach my $search (@keys)
	{
		$$rContent =~ s{$search}{$rhReplaceWith->{$search}}xmsg;
	}
	return $rContent;
}

sub make_file_dir
{
	my ($new_file) = @ARG;
	# TODO strip off file name (File::Basename dirname()
	# mkdir
}

grok_file('new.pl');
