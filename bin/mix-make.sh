#!/bin/bash
# run all mix tasks to make project up to date.
mix deps.get \
&& mix test \
&& mix escript.build \
&& mix docs

# mix run -e "Issues.CLI.default()"
# mix profile.fprof -e "Issues.CLI.default()"
