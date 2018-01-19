#!/bin/bash
# mulitline search/replace to fix BDD test files

cp $1 $1.bak
perl -e '
  local $/ = undef;
  $depth = $support = $conf = $json = $locator = $util = $log = $screen = $data = "";

  $_ = <>;

  my $q = chr(39);
  my $d = q{\.\.\/};
  if (s{$q$d$d$d$d$q}{depth}xmsg) {
    $depth = "var depth = $q../../../../$q;\n";
  }
  if (s{${q}tests/acceptance/wdio/features/support/}{supportDir + $q}xmsg) {
    $support = "var supportDir = ${q}tests/acceptance/wdio/features/support/$q;\n";
  }
  if (s{${q}tests/acceptance/wdio/conf/}{confDir + $q}xmsg) {
    $conf = "var confDir = ${q}tests/acceptance/wdio/conf/$q;\n";
  }
  if (s{${q}tests/acceptance/wdio/files/requestJsonFiles/}{jsonDir + $q}xmsg) {
    $json = "var jsonDir = ${q}tests/acceptance/wdio/files/requestJsonFiles/$q;\n";
  }
  if (s{${q}tests/acceptance/wdio/locators/common/}{locatorDir + $q}xmsg) {
    $locator = "var locatorDir = ${q}tests/acceptance/wdio/locators/common/$q;\n";
  }
  if (s{${q}tests/acceptance/wdio/utilities/errorLog/}{logDir + $q}xmsg) {
    $log = "var logDir = ${q}tests/acceptance/wdio/utilities/errorLog/$q;\n";
  }
  if (s{${q}tests/acceptance/wdio/utilities/}{utilDir + $q}xmsg) {
    $util = "var utilDir = ${q}tests/acceptance/wdio/utilities/$q;\n";
  }
  if (s{${q}tests/acceptance/wdio/screenshots/}{screenDir + $q}xmsg) {
    $screen = "var screenDir = ${q}tests/acceptance/wdio/screenshots/$q;\n";
  }
  if (s{${q}tests/acceptance/wdio/files/testData/}{dataDir + $q}xmsg) {
    $data = "var dataDir = ${q}tests/acceptance/wdio/files/testData/$q;\n";
  }

  my $include = "$depth$support$conf$json$locator$util$log$screen$data";
  unless (s{(require\(${q}path$q\);)}{$1\n$include}xms) {
    print STDERR "cannot find require(path) in order to substitute $include\n";
    $_ .= "\n// SHOULD BE AT TOP:\n$include\n";
  }
  print $_;
' $1.bak > $1
