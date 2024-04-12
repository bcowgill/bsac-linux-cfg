// @ts-check
import { defineConfig, devices } from '@playwright/test';

/**
 * Read environment variables from file.
 * https://github.com/motdotla/dotenv
 */
// require('dotenv').config();

const defaultBrand = 'brand';
const PORT=58008;
const brandBaseURL = { [defaultBrand]: `https://playwright.dev` };
// const brandBaseURL = { [defaultBrand]: `http://localhost:${PORT}` };

const brand = process.env.BRAND || defaultBrand;
const baseURL = process.env.BASE_URL || brandBaseURL[brand] || brandBaseURL[defaultBrand];
const timeout = process.env.TIMEOUT ? Number(process.env.TIMEOUT) : 60000;

let viewport;

if (process.env.VIEW) {
  const resolution = process.env.VIEW.split(/[x, ]/);
  if (resolution.length >= 2) {
    viewport = {
      width: parseInt(resolution[0], 10),
      height: parseInt(resolution[1], 10),
    };
  }
}

/**
 * @see https://playwright.dev/docs/test-configuration
 */
export default defineConfig({
  testDir: './tests',
  timeout,

  /* Run tests in files in parallel */
  fullyParallel: true,
  /* Fail the build on CI if you accidentally left test.only in the source code. */
  forbidOnly: !!process.env.CI,
  /* Retry on CI only */
  retries: process.env.CI ? 2 : 0,
  /* Opt out of parallel tests on CI. */
  workers: (process.env.CI || process.env.SLOMO) ? 1 : undefined,
  /* Reporter to use. See https://playwright.dev/docs/test-reporters */
  reporter: 'html',
  /* Shared settings for all the projects below. See https://playwright.dev/docs/api/class-testoptions. */
  use: {
    /* My custom config */
    my: {
      defaultBrand,
      brand,
    },
    /* Base URL to use in actions like `await page.goto('/')`. */
    baseURL,

    colorScheme: 'light', // dark
    viewport,
    locale: 'en-GB',
    timezoneId: 'Europe/London',
    geolocation: { latitude: 51.487395, longitude: 0 },
    permissions: ['geolocation'],

    /* Collect trace when retrying the failed test. See https://playwright.dev/docs/trace-viewer */
    trace: process.env.TRACE ? 'on' : 'on-first-retry',
    video: process.env.VIDEO ? 'on' : 'on-first-retry',
    screenshot: process.env.LENSCAP ? 'only-on-failure' : 'on',
    launchOptions: {
      slowMo: process.env.SLOMO ? 1500 : 0,
    }
  },

  expect: {
    // Maximum time expect() should wait for the condition to be met.
    timeout,

    // MUSTDO these have been configured, but not tested yet...
    toHaveScreenshot: {
      // An acceptable amount of pixels that could be different, unset by default.
      maxDiffPixels: 10,
    },

    toMatchScreenshot: {
      // An acceptable ratio of pixels that are different to the
      // total amount of pixels, between 0 and 1.
      maxDiffPixelRatio: 0.1,
    },
  },

  /* Configure projects for major browsers */
  projects: [
    // {
    //   name: 'chromium',
    //   use: { ...devices['Desktop Chrome'] },
    // },

    // {
    //   name: 'firefox',
    //   use: { ...devices['Desktop Firefox'] },
    // },

    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },

    /* Test against mobile viewports. */
    {
      name: 'MobileChrome',
      use: { ...devices['Pixel 5'] },
    },
    // {
    //   name: 'Mobile Safari',
    //   use: { ...devices['iPhone 12'] },
    // },

    /* Test against branded browsers. */
    {
      name: 'MicrosoftEdge',
      use: { ...devices['Desktop Edge'], channel: 'msedge' },
    },
    {
      name: 'GoogleChrome',
      use: { ...devices['Desktop Chrome'], channel: 'chrome' },
    },
  ],

  /* Run your local dev server before starting the tests */
  // webServer: {
  //   command: 'npm run start',
  //   url: 'http://127.0.0.1:3000',
  //   reuseExistingServer: !process.env.CI,
  // },
});

console.log(`PLAYWRIGHT TESTS RUNNING as: ${brand} against ${baseURL} ${process.env.VIEW || ""} timeout=${timeout} ${
  process.env.TRACE? ' TRACE': ''}${
  process.env.VIDEO? ' VIDEO': ''}${process.env.HAR_DEBUG? ' HAR_DEBUG': ''} ${
  process.env.HAR? ' HAR update': ''}${process.env.CI? ' CI': ''}${
  process.env.SLOMO? ' SLOMO': ''}`)
