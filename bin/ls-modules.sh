#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# list elixir modules found in git control
MODULES=`git grep defmodule lib/ | perl -pne 's{.+ defmodule \s+ (.+) \s+ do \s*}{$1\n}xmsg'`

echo $MODULES
