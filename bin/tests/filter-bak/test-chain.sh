#!/bin/bash

NEXT=filter-osfiles

./tests.sh
cd ../$NEXT
./test-chain.sh
