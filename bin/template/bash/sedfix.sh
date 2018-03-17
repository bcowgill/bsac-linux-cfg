# examples of using sed to search and replace instead of perl
sed -i 's#search#replace'${envvar}'.something#g' filename.conf

find ./pathname -type f -name 'filename.js' -exec sed -i 's#/some/path/#/other/path/#g' {} \;
