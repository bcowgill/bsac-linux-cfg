#!/bin/bash
# grep for typings information in clearbooks repos
git grep $* typings/ ; grep -r $* node_modules/@types/
