#!/bin/bash
git grep -l -E $* ~/bin | grep -vE '(cfg|template|english)/'
