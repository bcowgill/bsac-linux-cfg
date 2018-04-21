https://www.npmjs.com/package/benchmark
https://benchmarkjs.com/

yarn init
yarn add microtimer benchmark

bench-runner.js is where you configure your functions to benchmark.

template-module.js is a template for a module that works with any module loader in node or browser.

test-X.js create a new module for each test you want to run and include in bench-runner.js and index.html.

open index.html in a browser or yarn start to run the benchmarks.


converted to pnpm package manager
pnpm add microtimer benchmark lodash platform
git add shrinkwrap.yaml
