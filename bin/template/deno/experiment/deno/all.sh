#!/bin/bash
deno --version
# run all targets 
deno task check
deno lint
deno task lint:doc
deno fmt
deno task run
deno task doc

# non-terminating
deno task start &
deno task start:node &
sleep 3
curl http://localhost:3000
curl http://localhost:8000

deno task dev &
deno task test &

ps | grep deno | grep -v grep
