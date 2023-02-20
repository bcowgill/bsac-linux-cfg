#!/bin/bash
if echo $1 | grep test.ts; then
  npm run coverage -- --testPathPattern "$1"
else
  echo $1 is not a test plan.
  exit 1
fi
