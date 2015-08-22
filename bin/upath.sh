#!/bin/bash
# remove duplicate directories from the path
# PATH=`upath.pl`
# alias upath = 'PATH=`upath.pl`'
echo $PATH | perl -e '%Path = (); $path = <>; chomp($path); @Path = grep { if (exists($Path{$_})) { 0; } else { ++$Path{$_}; 1; }  } split(":", $path); print join(":", @Path);'
