#!/bin/bash
# test-one.sh src/__tests__/pii.test.ts > tests.log 2>&1; less tests.log

npm run test:one -- --testPathPattern "$1" | tee tests.log
