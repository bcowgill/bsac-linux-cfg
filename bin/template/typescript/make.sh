rm -rf dist;
json5 -c tsconfig*.json5 && tsc --newline LF --project tsconfig.json ;
#json5 -c tsconfig*.json5 && tsc --newline LF --project tsconfig-debug.json ;
#rm *.json

exit 0
mkdir trans
OUT=weird
#OUT=index-debug
MOD=amd.es6
(\
	echo "// weird.d.ts - $MOD";\
	cat dist/$OUT.d.ts;\
	echo " ";\
	echo "// weird.js - $MOD";\
	cat dist/$OUT.js\
) > trans/weird.$MOD
