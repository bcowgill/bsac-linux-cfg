#!/bin/bash

NEXT=filter-source

./tests.sh
cd ../$NEXT
./test-chain.sh