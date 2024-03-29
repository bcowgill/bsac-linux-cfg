#!/bin/bash
# refactor then perl template changes into all dependent scripts

DIFF=refactor
TOP=../..

diff ()
{
    vdiff.sh "$TOP/$1" "$TOP/$2"
}

rvdiff ()
{
    vdiff.sh "$TOP/$2" "$TOP/$1"
}

refactor ()
{
    diff "$1" "$2"
    rvdiff "$1" "$2"
}

$DIFF template/perl/perl.pl template/perl/perl-inplace.pl

BASE=template/perl/perl.pl

diff $BASE scan-js.pl
diff $BASE ls-tabs.pl

BASE=template/perl/perl-inplace.pl
diff $BASE render-tt.pl
diff $BASE filter-css-colors.pl
diff $BASE ls-tt-tags.pl
diff $BASE pretty-elements.pl
