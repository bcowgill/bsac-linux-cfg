#!/bin/bash

NEXT=filter-min

./tests.sh
cd ../$NEXT
./test-chain.sh
