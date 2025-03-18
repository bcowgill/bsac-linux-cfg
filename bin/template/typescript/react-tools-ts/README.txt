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
  - MUSTDO try with bun install / configure / unit test https://bun.sh/docs

Diffing changes back and forth:
from ubuntu usb key (bun,deno,tsx,node)

vdiff.sh tsrunner.ts tslangorg.txt; edit.sh tslangorg.txt
vsdiff.sh tslangorg.txt tscompiler.txt; edit.sh tscompiler.txt

and back again...
vsdiff.sh tslangorg.txt tsrunner.ts


Bun - pros/cons v1.2.5
	see ./bun-play directory for a sample

Pros
	drop in replacement for node to run JS/TS code faster.
	very fast runs TypeScript by stripping out type definitions
	compile to binary / bytecode - cross compile to other OS https://bun.sh/docs/bundler/executables
	init a bun project from a react component https://bun.sh/docs/cli/bun-create

Cons
	no static type checker need to use tsc for that

Once installed upgrade with:
bun upgrade --stable  # latest stable build
bun upgrade --canary  # for latest canary build

bun init  # quick start a new project

bun --watch run index.ts

bun build index.ts --compile --outfile dist/app  # build to a single executable
