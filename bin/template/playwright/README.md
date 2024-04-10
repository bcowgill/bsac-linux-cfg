To configure this for use on your own project:

package.json, playwright.config.js, config.js etc
  configure the scripts as needed, especially:
  :58008           the port number your local app runs on.
  viewport=600,800 the default browser size to use when recording tests.
  /channel-api/    glob for matching your App's API calls.
  test1            details of your usual testing environment you record from.
  @example,@slow,@iframe, etc for your testing tags.
  BRAND            for alternative brands of your app
  defaultBrand     the default brand/theme for your app
  brandBaseURL     the base url of your app by brand
  9988776655443    the fixed value for the random a= parameter in urls.
  PM=              to change the a= parameter name.
  PORT=58008

MUSTDO test package build scripts in JS / TS
vdiff JS files into typescript dir
set up eslint for JS tests then for typescript ones

JS/TS checked:
lint
format
record

JS only
record:api  change google.com url first -- har file is created
record:test1 change to google.com url first -- har file is created
devices -- saved dump to debug-spec.lst
   npm run devices 2>&1 | pee.pl debug-spec.lst
view
example
quick
test
visual
debug
debug:mobile
devtools
test:iframe
test:brand
test:mobile
test:edge
test:webkit
test:verbose
test:mockapi
test:all
test:all:brand
test:all:iframe

not tested:
update

testing where the screenshot function puts its output.
rm -rf screenshots/; ALL= npm test -- tests/template.spec.js ; find test-results -type f

for file in playwright.config tests/config tests/lib tests/ui tests/debug.spec tests/template.spec; do
  echo $file.js
  vdiff.sh $file.js typescript/$file.ts
done
tests/example.spec
tests/JIRA-NNNN-template-story.spec
tests-examples/demo-todo-app.spec

## Recording tests with 🎭Playwright

`npm run record -- site.com` - to open 🎭Playwright to begin recording manual tests against any given URL

`npm run record:api` - to open 🎭Playwright against your locally running app and record network API requests to a HAR file in `tests/bugs/har/bug.har`  The example test plan `tests/JIRA-NNNN-template-story.spec.js` demonstrates tests with mock API calls coming from a HAR file.

`npm run record:test1` - to manually record a bug from your testing environment as a 🎭Playwright test and capture the network API requests to a HAR file in `tests/bugs/har/test1.har`

## Debugging tests with 🎭Playwright

`npm run ui -- tests/test.spec.js` - to open the 🎭Playwright Test Runner UI with a specific test plan (or omit it for all tests).  This lets you run tests one at a time or set to watch to rerun them after every code change.

`npm run trace -- tests/test.spec.js` - to run a test and create a 🎭Playwright trace.zip with a specific test plan.  The trace can be given to someone else to view separately and fully inspect every step of the test without needing 🎭Playwright installed.  After the trace is recorded, the report is opened.  Can be used by QA engineers who first record the issue with `npm run record` then use this to generate the trace to give to developers to demonstrate the issue and let them do preliminary debugging without needing access to the testing environment.

`npm run debug -- tests/test.spec.js` - to open 🎭Playwright and step through a specific test plan one line at a time.

`npm run debug:mobile -- tests/test.spec.js` - to open 🎭Playwright with a mobile device viewport and step through a specific test plan one line at a time.

`npm run devices` - runs the `tests/debug.spec.js` test to show the list of device formats available for testing. And to debug the 🎭Playwright Page and testInfo objects.

`npm run visual -- tests/test.spec.js` - runs a test plan with delay between actions so that you can see what is happening, useful for recording a video of an app journey.

## Running the tests and viewing the report

`npm run view` - after running a set of tests this will show the test report in your browser.

`npm run report` - will run the tests with default tag filters and then open the report automatically.

MUSTDO -
`npm run example`
`npm run quick`
`npm run test`
`npm run ui`
`npm run trace`
`npm run viewtrace`
`npm run devtools`


`npm run test:...`

## Code quality

`npm run format` - will format all the code to standard style, and run linting tasks to highlight any issues.

`npm run eslint:fix` - will fix any lint issues which can be automatically fixed.


