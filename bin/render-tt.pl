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





   'nothing' => 'title of page',
   'campaign_id' => 42,
   'base_campaign_id' => 67,
   'approval_id' => 23,
   'isAgencyCampaign' => 0,
   'targeting_type' => 'TargType',
   'targeting_type_name' => 'TargTypeName',
   'dashboard_user' => {
      'organisation_type' => 'superuser' # also agency
   },
   'clients' => [
      {
         'id' => 12,
         'name' => 'client 1',
      },
      {
         'id' => 52,
         'name' => 'client 2',
      }
   ],

};

my $oTemplate = Template->new({
   INCLUDE_PATH => '.',
   INTERPOLATE => 1,
}) || die "$Template::ERROR\n";

$oTemplate->process($template, $rhVars)
   || die $oTemplate->error(), "\n";
