#!/bin/bash

NEXT=filter-script

./tests.sh
cd ../$NEXT
./test-chain.sh
