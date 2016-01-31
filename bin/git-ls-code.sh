#!/bin/bash
# list the source code files that are under git control
# ignores binaries like archives, pictures, sounds, documents, databases, executables
git grep -l . | egrep -vi '\.(tar|zip|gz|tar\.gz|rar|jar|png|gif|ico|jpe?g|mp[34]|avi|wmv|mov|svg|pdf|psd|pp[st][mx]?|pot[mx]?|exe|dll|msg|class|obj|swf|[ct]sv|rtf|doc[mx]?|dot[mx]?|od[st]|xl[st][mxb]?|ttf|eot|woff|patch|ics|pem|rdb|sqlitedb(-(shm|wal))?)$'
