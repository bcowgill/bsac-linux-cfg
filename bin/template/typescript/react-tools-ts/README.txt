React Testing Tools for use with react-testing-library

tscompiler.txt paste and run in browser: https://onecompiler.com/typescript/43awqp4hr
  - no unicode output is allowd so EX_UTF_OK=false
tslangorg.txt paste and run in browser: https://www.typescriptlang.org/play/?module=1
  - unicode is ok so can run with EX_UTF_OK true or false
  - then go to JS tab and copy the content to tslangorg.js.txt
tslangorg.js.txt to run in node v17+ `nvm use`
  - run go.sh which will fix the switches in this file and above
  - run ./tslangorg.js  symbolic link

tsrunner.ts can run natively with tsx, deno or bun as they detect where they are running
  - tsx ./tsrunner.ts
  - deno ./tsrunner.ts
  - bun ./tsrunner.ts
  TODO ??? can I run tsx as a REPL and find something that differs from deno/bun/node???

Diffing changes back and forth:

vsdiff.sh tslangorg.txt tscompiler.txt
vsdiff.sh tslangorg.txt tsrunner.ts
