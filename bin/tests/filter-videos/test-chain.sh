#!/bin/bash

NEXT=filter-drawings

./tests.sh
cd ../$NEXT
./test-chain.sh
