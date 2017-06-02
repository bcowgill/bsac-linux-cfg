rm -rf dist;
#json5 -c tsconfig*.json5 && tsc --newline LF --project tsconfig.json ;
#json5 -c tsconfig*.json5 && tsc --newline LF --project tsconfig-debug.json ;
#rm *.json

mkdir trans
SRC=weird
OUT=weird
#OUT=index-debug
MOD=es2015.es5

tar czf typescript.tgz *.ts modules/
rm -rf src
mkdir src/
cp $SRC.ts src/
rm -rf *.ts modules/

json5 -c tsconfig*.json5 && tsc --newline LF --project tsconfig-$MOD.json ;

(\
	echo "// $SRC.d.ts - $MOD";\
	cat dist/$OUT.d.ts;\
	echo " ";\
	echo "// $SRC.js - $MOD";\
	cat dist/$OUT.js\
) > trans/$SRC.$MOD
tar xzf typescript.tgz
echo created trans/$SRC.$MOD
