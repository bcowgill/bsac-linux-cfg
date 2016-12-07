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
