#!/bin/bash
#./test-chain.sh | grep -E 'TEST|NOT OK'

NEXT=filter-coverage

./tests.sh
cd ../$NEXT
./test-chain.sh
