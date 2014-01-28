#!/bin/bash
# Turn on version number keyword substitutions for a file in SVN
# MUST commit the file before it takes effect
svn propset svn:keywords "Date,Revision,Rev,Id,Author,HeadURL,URL,Header" $*
svn commit $*
