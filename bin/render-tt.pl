#!/usr/bin/env perl
# render a template toolkit page using some hard coded settings read from file

use strict;
use warnings;
use English -no_match_vars;
use Data::Dumper;
use Template;

my $template = "in/template-toolkit-test.tt";
my $params = "in/template-toolkit-test.vars";
my $rhVars = {
   'value' => 'value value',
   'this' => { 'that' => 'value this.that' },
   'obj' => { 'id' => 'value obj.id' },
};

my $oTemplate = Template->new({
   INCLUDE_PATH => '.',
   INTERPOLATE => 1,
}) || die "$Template::ERROR\n";

$oTemplate->process($template, $rhVars)
   || die $oTemplate->error(), "\n";
