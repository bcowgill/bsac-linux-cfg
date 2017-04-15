rm -rf dist;
json5 -c tsconfig*.json5 && tsc --newline LF --project tsconfig.json ;
rm *.json
