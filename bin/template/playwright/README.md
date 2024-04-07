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
