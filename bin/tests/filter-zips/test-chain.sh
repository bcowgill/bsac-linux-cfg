#!/bin/bash

NEXT=filter-built-files

./tests.sh
cd ../$NEXT
./test-chain.sh
