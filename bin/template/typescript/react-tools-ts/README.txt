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
  - MUSTDO bun-play/vite try the bun create vite example https://bun.sh/guides/ecosystem/vite

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
	can patch files in node_modules in a selective way (for debuggine, etc) so it doesn't affect other projects which use the same package https://bun.sh/docs/install/patch
	can build a single page app from an index.html starting file

Cons
	no static type checker need to use tsc for that (install typescript)
	run front end and mock api server full stack with one file https://bun.sh/docs/bundler/fullstack
	macro functions that run at build time but don't appear in the built code
	--coverage does not yet support HTML view/drill down

Once installed upgrade with:
bun upgrade --stable  # latest stable build
bun upgrade --canary  # for latest canary build

bun init  # quick start a new project
bun create Component.tsx  # create a dev environment from a react component

bun run index.ts
bun --watch run index.ts
BUN_CONFIG_VERBOSE_FETCH=curl bun --inspect-brk index.ts  # debug code (ie with chromium) and insert a breakpoint immediately
BUN_CONFIG_VERBOSE_FETCH=curl bun --inspect-wait index.ts  # debug code, susped execution until debugger attaches
go to https://debug.bun.sh/ to debug the code (or firefox/chrome and use the link printed by the inspector)
Or install Bun VSCode extension https://bun.sh/guides/runtime/vscode-debugger

bun build index.ts --compile --outfile dist/app  # build to a single executable
