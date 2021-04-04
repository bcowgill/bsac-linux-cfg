# Mocha Dark

The purpose of this is to show use of the mocha test runner and dark color scheme for:

* testing node code.
* testing in the browser.
* npm configured to run tests, watch tests or run 1 test plan only.
* configure using json5 instead of package.json
* configure to run tests in src/ or test/ dir as .test.js or .spec.js

Note, source env.local before doing anything. it aliases npm to npm-json5

rename .test.js as .skip.js if they demonstrate a failing test, you can run them manually as below.

Testing mocha dark color scheme:

Run a single test plan:

npm run test1 test/a-failing-test.skip.js
  -- to see how failing tests look (normally skipped)

npm run test1 test/a-first-test.test.js
  -- to see how passing tests look


npm run testall
  -- to run even skip.js tests


TODO

* node version of perl -pne filtering
* test es6/7 code using node harmony
* get coverage running
* babel to transpile to es5 and test
* test against es5 generated code
* webpack and tests working
* benchmark some code and have it pass/fail based on time
* example async code tests (callback, promise)
* example time dependent test
* example setTimeout dependent test
* example spy/mock test
