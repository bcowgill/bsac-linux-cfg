#!/bin/bash
# online file extension database https://fileinfo.com/extension/pdf
find-code.sh $* | egrep -i '\.(docx?|dot[mx]?|eps|od[fstp]|pdf|pp([dt]|tx)|ps|rtf|xlsx?|xltx)$' # 


