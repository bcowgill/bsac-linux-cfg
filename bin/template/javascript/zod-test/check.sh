INDENT_TAB=0 fix-spaces.sh index.ts
echo === index.ts
ls-tabs.pl --spaces=3 index.ts | tail -5
echo === index.js
ls-tabs.pl --spaces=3 index.js | tail -5
