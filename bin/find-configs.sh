#!/bin/bash
# online file extension database https://fileinfo.com/extension/cfg
find-code.sh $* | egrep -i '\.(cfg|conf(ig)?|ini|reg|(x|ya?)ml)$' # xml yml yaml
