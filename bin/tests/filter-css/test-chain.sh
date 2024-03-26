#!/bin/bash

NEXT=filter-code-files

./tests.sh
cd ../$NEXT
./test-chain.sh
