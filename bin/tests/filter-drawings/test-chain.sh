#!/bin/bash

NEXT=filter-fonts

./tests.sh
cd ../$NEXT
./test-chain.sh
