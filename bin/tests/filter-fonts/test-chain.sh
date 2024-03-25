#!/bin/bash

NEXT=filter-docs

./tests.sh
cd ../$NEXT
./test-chain.sh
