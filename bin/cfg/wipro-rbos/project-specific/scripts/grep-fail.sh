#!/bin/bash
# search test run logs for common failures / issues
# TODO add the x unicode character cross rom a failed test
grep -A1 -E '\bFAIL\s|failed|Warning:|Error:|console\.error|DeprecationWarning|Unhandled|skip|MUSTDO|\b[tT][oO]-?[dD][oO]\b|Ran all test suites matching|=========='
