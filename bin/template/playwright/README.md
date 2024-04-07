To configure this for use on your own project:

package.json
  configure the scripts as needed, especially:
  :58008           the port number your local app runs on.
  viewport=600,800 the default browser size to use when recording tests.
  /channel-api/    glob for matching your App's API calls.
  test1            details of your usual testing environment you record from.
  @example,@slow,@iframe, etc for your testing tags.
  BRAND            for alternative brands of your app
  9988776655443    the fixed value for the random a= parameter in urls.
  PM=              to change the a= parameter name.

MUSTDO test package build scripts in JS / TS

JS
lint
format
record
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
