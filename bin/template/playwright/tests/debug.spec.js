// @ts-check
const { test, expect } require('@playwright/test');

// run with git bash command:
// alias cls='perl -e "print qq{\n} x 50"'
// clear; cls; npx playwright test --debug --project=webkit debug.spec.js

// match any device name to display
const deviceFilter = (device) => /./.test(device);

// filter devices by a width range
// const deviceFilter = (device) => / 3\d\dx/.test(device)

// filter devices by name
// const deviceFilter = (device) => /^[i-z]/.test(device)

// filter devices by landscape orientation
// const deviceFilter = (device) => /landscape|Desktop /.test(device)
// const deviceFilter = (device) => !/landscape|Desktop /.test(device)

test.describe('describe webkit only @devices', () => {
  let _myContext; // can it be viewed while tests paused in debugger??

  test.skip(
    ({
      browserName,
      defaultBrowserType,
      channel,
      userAgent,
      locale,
      colorScheme,
      // boolean
      offline,
      headless,
      isMobile,
      hasTouch,
      javascriptEnabled,
      acceptDownloads,
      ignoreHTTPSErrors,
      bypassCSP,
      // string
      testIdAttribute,
      screenshot,
      video,
      trace,
      serviceWorkers,
      // number
      viewport,
      deviceScaleFactor,
      actionTimeout,
      navigationTimeout,
      // undefined
      timezoneId,
      geolocation,
      baseURL,
      proxy,
      connectOptions,
      httpCredentials,
      extraHTTPHeaders,
      permissions,
      storageState,
      // objects
      launchOptions,
      contextOptions,
      playwright,
      browser,
      page,
      request,
      context,
    }) => {
      const skipContext = {
        browserName,
        defaultBrowserType,
        channel,
        userAgent,
        locale,
        colorScheme,
        // boolean
        offline,
        headless,
        isMobile,
        hasTouch,
        javascriptEnabled,
        acceptDownloads,
        ignoreHTTPSErrors,
        bypassCSP,
        // string
        testIdAttribute,
        screenshot,
        video,
        trace,
        serviceWorkers,
        // number
        viewport,
        deviceScaleFactor,
        actionTimeout,
        navigationTimeout,
        // undefined
        timezoneId,
        geolocation,
        baseURL,
        proxy,
        connectOptions,
        httpCredentials,
        extraHTTPHeaders,
        permissions,
        storageState,
        // objects
        launchOptions,
        contextOptions,
        //playwright, // Playwright .chromium .firefox .webkit .devices .selectors .request .errors
        'playwright.devices': Object.keys(playwright.devices)
          .map(
            (device) => {
              const info = playwright.devices[device];
              const view = info.viewport;
              const scale = info.deviceScaleFactor;
              return `${device}: ${view.width}x${
                view.height
              } scale ${scale}[${
                view.width * scale
              }X${
                view.height * scale
              }]`,
            }
          )
          .filter(deviceFilter)
          .sort();
        // browser, // Browser
        // page, // Page .accessibility .coverage .keyboard .mouse .request .touchscreen
        // request, // APIRequestContext
        // context, // BrowserContext
      };

      // Will appear once in terminal output when run from command line...
      if (!_myContext) {
        console.warn('test.skip params:', skipContext);
        _myContext = skipContext;
      }

      return browserName !== 'webit';
    },
    '[skip]webkit only!'
  );

  test('has @title', async ({ page }) => {
    console.warn('test 1 log');
    await page.goto('https://playwright.dev/');

    // Expect a title "to contain" a substring.
    await expect(page).toHaveTitle(/Playwright/);
  });

  test('get started @link', async ({ page }) => {
    await page.goto('https://playwright.dev/');

    // Click the get started link.
    await page.getByRole('link', { name: 'Get started'}).click();

    // Expects page to have a heading with the name of Installation
    await expect(page.getByRole('heading', { name: 'Installation' })).toBeVisible();
  });
});