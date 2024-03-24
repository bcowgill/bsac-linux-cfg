#!/bin/bash

NEXT=filter-videos

./tests.sh
cd ../$NEXT
./test-chain.sh
