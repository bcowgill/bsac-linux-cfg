find /Applications -name *.app | perl -pne 'chomp; s{\A (.+/) (.+\.app) $}{$2 $1}xmsg; $_ .= "\n"'
