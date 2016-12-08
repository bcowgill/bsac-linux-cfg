#!/bin/bash
# run all the mix commands to give a summary of an elixir project
for cmd in hex.info app.tree deps.tree hex.outdated escript archive deps
do
	echo mix $cmd =====================================================
	mix $cmd
	echo
done

for cmd in warnings unreachable graph
do
	echo mix xref $cmd =====================================================
	mix xref $cmd
	echo
done

MODULES=`git grep defmodule lib/ | perl -pne 's{.+ defmodule \s+ (.+) \s+ do \s*}{$1\n}xmsg'`
FILES=`find lib/ -name '*.ex' -o -name '*.exs'`

echo MODULES=$MODULES
echo FILES=$FILES

echo mix xref callers =====================================================
for mod in $MODULES
do
	mix xref callers $mod
done

echo mix xref graph --source  =============================================
for file in $FILES
do
	mix xref graph --source $file
done

echo mix xref graph --sink  ===============================================
for file in $FILES
do
	mix xref graph --sink $file
done

echo mix test --trace  ====================================================
mix test --trace
# mix test --stale --listen-on-stdin useful
