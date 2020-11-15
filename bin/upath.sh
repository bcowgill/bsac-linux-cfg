#!/bin/bash
# remove duplicate directories from the path
# PATH=`upath.sh`
# alias upath = 'PATH=`upath.sh`'
# WINDEV tool useful on windows development machine
echo $PATH | perl -e '%Path = (); $path = <>; chomp($path); @Path = grep { if (exists($Path{$_})) { 0; } else { ++$Path{$_}; 1; }  } split(":", $path); print join(":", @Path);'
