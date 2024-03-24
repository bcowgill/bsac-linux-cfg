#!/bin/bash
pushd filter-long > /dev/null
./test-chain.sh | grep -E 'TEST|NOT OK'
popd > /dev/null
