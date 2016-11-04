# list props/state/types/context definitions/uses from react components
perl -ne 's{((?:types|props|state|context)\.)(\w+)}{$Found{$1.$2} = 1}xmsge; END { print join("\n", sort keys %Found)}' $*
