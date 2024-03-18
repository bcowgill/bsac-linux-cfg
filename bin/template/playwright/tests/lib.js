import { expect } from 'playwright/test';
import {
  BASE_API_GLOB,
  API_ALL,
  updateHar,
  brand,
  defaultBrand,
  KBAUTH,
  renewAndPayPolicy,
} from './config';

const MAX_URL = 128;
const ELLIPSIS = '…';
const PAD = 3;
const ZEROS = Number.MAX_SAFE_INTEGER.toString().replace(/[1-9]/g, '0');
const PORT=58008;
const PM = 'a'; // name for a= parameter
const CACHE = '9988776655443'; // fixed value for a= parameter
const reAParam = new RegExp(`([?&]${PM})=\\d+`); // random number in URL for a= cache busting

const UI_DEFAULT = {
  brand: 'UI.VALUE for brand must be passed to uiText() or other function.',
};

/**
 * answer with true if a specific app brand has a given UI.VALUE configured.
 * @param {string|number|boolean|RegExp|{brand?: string|number|boolean|RegExp}} multiTextIn some setting for all brands or varying across brands.
 * @param {string} withBrand specifies which app brand value to check. defaults to process.env.BRAND value
 * @returns {boolean} indicates whether there is a UI value configured for the brand given.
 */
export function uiHas(multiTextIn, withBrand = brand) {
  if (!(withBrand in UI_DEFAULT)) {
    throw new RangeError(`uiHas() Invalid App Brand [${withBrand}] provided`);
  }
  const multiText = multiTextIn || {};
  if (multiText instanceof RegExp || typeof multiText !== 'object') {
    return true;
  }
  if (withBrand in multiText) {
    return true;
  }
  if (defaultBrand in multiText) {
    return true;
  }
  return false;
} // uiHas()

/**
 * answer with value (mostly string, number or regex) for a specific app brand from a UI.VALUE
 * @param {string|number|boolean|RegExp|{brand?: string|number|boolean|RegExp}} multiTextIn some setting for all brands or varying across brands.
 * @param {string} withBrand specifies which app brand value to check. defaults to process.env.BRAND value
 * @returns {string|number|boolean|RegExp} provides the UI value configured for the brand given.
 */
export function uiText() {
  if (!(withBrand in UI_DEFAULT)) {
    throw new RangeError(`uiHas() Invalid App Brand [${withBrand}] provided`);
  }
  const multiText = multiTextIn || UI_DEFAULT;
  if (multiText instanceof RegExp || typeof multiText !== 'object') {
    return multiText;
  }
  if (withBrand in multiText) {
    return multiText[withBrand];
  }
  if (defaultBrand in multiText) {
    return multiText[defaultBrand];
  }
  return UI_DEFAULT[withBrand];
} // uiText()

/**
 * answers with a string of zero padded digits for the given counter number.
 * @param {number} counter the number to pad with leading zeros.
 * @param {number} width the width to pad to, defaults to PAD value.
 * @returns {string} of zero padded digits for counter. i.e. "001"
 */
export function padZeros(counter, width = PAD) {
  const length = counter.toString().length;
  const pad = Math.max(width, length);
  const number = `${ZEROS.substring(0, pad - length)}${counter}`;
  return number;
} // padZeros()

/**
 * answers with a string shortened to the given length and with an ellipsis to indicate there was more.
 * @param {string} message the string to shorten if it is too long.
 * @param {number} max the maximum length of the string to allow. default is MAX_URL.
 * @param {string} ellipsis the character or string to use to indicate there was more. default is ELLIPSIS.
 * @returns {string} shortened message whose length will be at most max + ellipsis.length characters.
 */
export function shorten(message, max = MAX_URL, ellipsis = ELLIPSIS) {
  let shorter = message;
  if (shorter.length > max) {
    shorter = shorter.substring(0, max) + ellipsis;
  }
  return shorter;
} // shorten()

/**
 * answer with the screen shot directory to use for a test suite based on browser information and test information.
 * @param {Object} options options for taking the screen shot.
 * @param {string} options.brand the brand name with default 'brand'.
 * @param {string} options.spec the top level directory with default 'screenshots' intended to match the playwright generated test output dir like 'test-results/test-1-Home-Page-content-webkit/test-finished-1.png' if possible.
 * @param {string} options.suite the prefix name for current test suite with default 'suite'.
 * @param {string} options.channel the browser channel name from playwright.
 * @param {string} options.browserName the browser name from playwright with default 'browser'.
 * @param {string} options.defaultBrowserType the default browser type from playwright name with default 'browser'
 * @param {boolean} options.isMobile the mobile flag from playwright.
 * @param {{width, height}} options.viewport the viewport object from playwright.
 * @returns {string} the path and filename prefix to use for making screen shots in a test.
 * @example return something like 'screenshots/chromium-mobile-383x727/brand/home/home-'
 */
export function screenshotPath({
  brand= 'brand',
  spec = 'screenshots',
  suite = 'suite',
  channel,
  browserName = 'browser',
  defaultBrowserType = 'browser',
  isMobile = false,
  viewport,
}) {
  const vp = viewport || { width: 'W', height: 'H' };
  const browser = `${channel ? channel : browserName}-${defaultBrowserType}${
    isMobile ? '-mobile' : ''
  }`.replace(/^([\w-]+)-\1/, '$1');
  const resolution = `${browser}-${vp.width}x${vp.height}`;
  const screenshots = `${spec}/${resolution}/${brand}/$suite{}`;
  const prefix = `${screenshots}/${suite}`;
  return prefix;
} // screenshotPath()

/**
 * answers with a function that can be used to take numbered and named screen shots.
 *
 * @param {Object} options options for creating the camera output path and default screen shot options.
 * @param {string} options.brand the brand name with default 'brand'.
 * @param {string} options.spec the top level directory with default 'screenshots' intended to match the playwright generated test output dir like 'test-results/test-1-Home-Page-content-webkit/test-finished-1.png' if possible.
 * @param {string} options.suite the prefix name for current test suite with default 'suite'.
 * @param {string} options.channel the browser channel name from playwright.
 * @param {string} options.browserName the browser name from playwright with default 'browser'.
 * @param {string} options.defaultBrowserType the default browser type from playwright name with default 'browser'
 * @param {boolean} options.isMobile the mobile flag from playwright.
 * @param {boolean} options.fullPage default is true, to take a screen shot of the full browser page..
 * @param {{width, height}} options.viewport the viewport object from playwright.
 * @returns a screen shot function which increments the filename number and does full screen by default.
 */
export function getCamera({
  brand= 'brand',
  spec = 'screenshots',
  suite = 'suite',
  channel,
  browserName = 'browser',
  defaultBrowserType = 'browser',
  isMobile = false,
  fullPage = true,
  viewport,
}) {
  const full = fullPage;
  const prefix = screenshotPath({
    brand,
    spec,
    suite,
    channel,
    browserName,
    defaultBrowserType,
    isMobile,
    viewport,
  });

  /**
   * saves a full screen shot (by default) to a predefined directory and name.
   * @param {Object} options options for naming and numbering the screen shot.
   * @param {Page|Locator} options.page the page or locator to take a screen shot of.
   * @param {string} options.path the suffix to add to the file name after the number.
   * @param {number} options.counter the number to add to the file name to keep your screen shots in order.
   * @param {boolean} options.fullPage used to override the default fullPage value used when getCamera() was called.
   * @note page can be a page, or a locator like page.getByTestId('id').
   */
  return async function screenshot({ page, path, counter = 0, fullPage = full }) {
    const number = padZeros(counter);
    const fullPath = `${prefix}-${number}-${path}.png`.replace(/\.png/i, '.png');
    ++counter;
    if (!process.env.LENSCAP) {
      await page.screenshot({ path: fullPath, fullPage });
    }
  };
} // getCamera()

/**
 * this will log all HTTP requests made my the application under test to help debug your route mocks.
 * @param {Page} page whose routes you wish to log for debugging.
 * @param {string} urlMatch defaults to all URL's. you can specify an alternate glob to restrict what is logged.
 */
export async function traceRoutes(page, uriMatch = API_ALL) {
  await page.route(uriMatch, async (route, request) => {
    const url = shorten(request.url());
    console.warn(`ROUTE [match: ${uriMatch}]\n   ${request.method()} ${url}`);
    await route.fallback();
    return;
  });
} // traceRoutes()

/*
➡	U+27A1	[OtherSymbol]	BLACK RIGHTWARDS ARROW
⬅	U+2B05	[OtherSymbol]	LEFTWARDS BLACK ARROW
⇨	U+21E8	[OtherSymbol]	RIGHTWARDS WHITE ARROW
⇦	U+21E6	[OtherSymbol]	LEFTWARDS WHITE ARROW
⇽	U+21FD	[MathSymbol]	LEFTWARDS OPEN-HEADED ARROW
⇾	U+21FE	[MathSymbol]	RIGHTWARDS OPEN-HEADED ARROW
⟵	U+27F5	[MathSymbol]	LONG LEFTWARDS ARROW
⟶	U+27F6	[MathSymbol]	LONG RIGHTWARDS ARROW
⟸	U+27F8	[MathSymbol]	LONG LEFTWARDS DOUBLE ARROW
⟹	U+27F9	[MathSymbol]	LONG RIGHTWARDS DOUBLE ARROW
*/

//const RIGHT = ">>";
//const LEFT = "<<";

const RIGHT = "➡"; // U+27A1	[OtherSymbol]	BLACK RIGHTWARDS ARROW
const LEFT = "⬅"; // U+2B05	[OtherSymbol]	LEFTWARDS BLACK ARROW
/**
 * trace all network requests and responses, very noisily...
 * @param {Page} page whose routes you wish to log for debugging.
 */
export function traceNetwork(page) {
  // Subscribe to 'request' and 'response' events.
  page.on('request', (request) => console.log(RIGHT, request.method(), shorten(re.url())));
  page.on('response', (response) => console.log(LEFT, response.status(), shorten(re.url())));
} // traceNetwork()

/**
 * shows the HTTP requests and response codes from a HAR json file that has been imported.
 * @param {{ log: { entries: [{request: { method: string, url: string}, response: { status: number, statusText: string}}]} }} har a recorded .har.json file imported as a JSON object directly.
 * @param {(string) => string} sanitiseUrl function cleans up a url for comparison with another url.
 */
export function dumpHAR(har, sanitiseUrl = identity) {
  har.log.entries.map((entry) =? {
    console.warn(`HAR ${RIGHT} ${entry.request.method} ${sanitiseUrl(entry.request.url)}`);
    console.warn(`HAR ${LEFT} ${entry.response.status} ${entry.response.statusText}`);
  });
} // dumpHAR()

/**
 * answers with the parameter itself.
 * @param {any} item which should be returned as is.
 * @returns {any} the item.
 */
export function identity(item) {
  return item;
} // identity()

/**
 * answers with the cleaned up URL as localhost:58008 with a=NNN so that API URL comparisons from HAR files will work.
 * see local script fix-har.sh if you need to fix up a HAR file to match.
 * @param {string} url to be cleaned up before comparison to another clean url.
 * @returns {string} will replace localhost port with 58008 and a= parameter with a fixed number.
 */
export function fixCacheBusterParam(url) {
  return url.replace(/(localhost):\d+/, `$1:${PORT}`).replace(reAParam, `$1=${CACHE}`);
} // fixCacheBusterParam()

/**
 * custom page.routeFromHAR() which handles a= URL parameter
 * and local host port numbers automatically.
 * see local script fix-har.sh if you need to fix up a HAR file to match.
 * @param {Page} page whose routes you wish to configure from HAR file.
 * @param {string} harFile path to .har file containing recorded network requests.
 * @param {Object} options same options as routeFromHAR() with some additions.
 * @param {(url: string) => string} options.sanitiseUrl function to clean up the URL before looking in the HAR file.  defaults to fixCacheBusterParam().
 * @param {boolean} options.debug turn on some console logging to diagnose sanitiseUrl() if needed. defaults to HAR_DEBUG environment value.
export async function myRouteFromHAR(
  page,
  harFile,
  {
    url = BASE_API_GLOB,
    sanitiseUrl = fixCacheBusterParam,
    notFound = 'abort',
    update = updateHar,
    debug = !!process.env.HAR_DEBUG,
    ...rest
  } = {}
) {
  if (debug) {
    console.warn(`myRouteFromHAR [${harFile}]`, { url, notFound, update, ...rest });
  }
  let showAParamWarning = true;
  await page.routeFromHAR(harFile, {
    url,
    notFound,
    update,
    ...rest,
  });
  // clean up the url BEFORE it gets looked up in HAR file above
  // https://github.com/microsoft/playwright/issues/21405#issuecomment-1741979612
  await page.route(url, (route) => {
    const urlRequest = route.request().url();
    if (showAParamWarning && !reAParam.test(urlRequest)) {
      console.warn(
        `\n\nmyRouteFromHAR: 👋 Greetings from the past! 👋 \nIt appears that you have removed the ?${PM}= parameter from API calls.\nThat's great but you might have to remove them all from your test .har.json files as well.\nYou can do this with the fix-har.sh script in a git bash shell:\n\n   STRIPA=1 ./scripts/fix-har.sh \`find tests -name "*.har.json"\`\n\nOnce you have done that, you can remove this warning message.\n\n`,
      );
      showAParamWarning = false;
    }
    const urlClean = sanitiseUrl(urlRequest);
    if (debug) {
      console.warn(`myRouteFromHAR FIX ${PM}= URL param`, urlClean);
    }
    route.fallback({ url: urlClean });
  });
} // myRouteFromHAR()

/**
 * answers with true if the POST data from one request matches the POST data from a HAR file.
 * @param {Object} postData the POST request data to compare.
 * @param {Object} harPostData the POST request data from a HAR file for comparison.
 * @returns {boolean} will be true if both POST requests have identical keys and values.
function matchPostData(postData = {}, harPostData = {}) {
  if (Object.keys(postData).length !== Object.keys(harPostData).length) {
    return false;
  }
  let match = true;
  Object.keys(postData).forEach((key) => {
    if (postData[key] !== harPostData[key]) {
      match = false;
    }
  });
  return match;
} // matchPostData()

/**
 * fulfills a route with an entry from a .har.json file.
 * @param {Route} route a network request to route to some response data.
 * @param {{response: { status: number, content: { mimeType: string, text: string}, headers: [{name: string, value: string}]}}} harEntry one of the .log.entries values from a HAR json file recording API calls from a test run.
 * @param {boolean} debug true to log the json being sent during debugging.
 */
export async function fulfillHAR(route, harEntry, debug = process.env.HAR_DEBUG === '2') {
  const response = harEntry.response;
  const res = {
    status: response.status,
    contentType: response.content.mimeType,
    body: response.content.text,
    headers: response.headers,
  };
  if (debug) {
    console.log(`SENDING ${LEFT}`, res);
  }
  await route.fulfill(res);
} // fulfillHAR()
