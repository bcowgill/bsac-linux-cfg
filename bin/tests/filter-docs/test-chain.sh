#!/bin/bash

NEXT=filter-bak

./tests.sh
cd ../$NEXT
./test-chain.sh