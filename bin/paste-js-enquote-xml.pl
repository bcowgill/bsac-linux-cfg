#!/usr/bin/env perl
# take a pasted bunch of javascript and enquote it as XML element text
# used for storing code in XML configuration files

use strict;
use warnings;
use English qw(-no_match_vars);

my $input;
local $INPUT_RECORD_SEPARATOR = undef;
$input = <STDIN>;
$input =~ s{&}{&amp;}xmsg;
$input =~ s{<}{&lt;}xmsg;
$input =~ s{>}{&gt;}xmsg;
print qq{$input};

__END__
(function () {
  var el = document.getElementById('<?>');
  el.style.height='1024px';
  el.style.width='100%';

  if (Ontology && Ontology.CCA && Ontology.CCA.loadAssets)
  {
    var obj = Ontology.CCA;
    obj.loadAssets(function () {

Becomes

(function () {
  var el = document.getElementById('&lt;?&gt;');
  el.style.height='1024px';
  el.style.width='100%';

  if (Ontology &amp;&amp; Ontology.CCA &amp;&amp; Ontology.CCA.loadAssets)
  {
    var obj = Ontology.CCA;
    obj.loadAssets(function () {

