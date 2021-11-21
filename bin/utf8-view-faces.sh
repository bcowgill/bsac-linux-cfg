#!/bin/bash
browser.sh "file://`echo $0 | perl -pne 's{/[^/]+\z}{/template/html/faces-utf8.html}'`"
