#!/bin/bash

NEXT=filter-zips

./tests.sh
cd ../$NEXT
./test-chain.sh
