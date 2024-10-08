#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# online file extension database https://fileinfo.com/extension/pdf
# WINDEV tool useful on windows development machine
find-code.sh $* | egrep -i '\.(docx?|dot[mx]?|eps|od[fstp]|pdf|pp([dt]|tx)|ps|rtf|xlsx?|xltx)$' # .odf .ods .odt .odp .ppd .ppt .pptx
