import { test, expect } from 'playwright/test';
import { PAGE_URL /*BASE_API_GLOB, */ } from './config';
import { setupTest, uiText, myRouteFromHAR, invoke } from './lib';
import { J_HOME_TITLE } from './ui';

// A template for a story which tests against a mock api or against a
// recorded HAR file for API responses.

const suite = 'JOURNEY';

const harFile = 'tests/har/JIRA-NNNN.har.json';

// const PAGE_TITLE = 'TITLE';
// const PAGE_HEADING = 'HEADING';
const PAGE_TITLE = uiText(J_HOME_TITLE);
const PAGE_HEADING =
  'Playwright enables reliable end-to-end testing for modern web apps.';

const shutter = setupTest({
  suite,
  url: PAGE_URL,
  title: PAGE_TITLE,
  heading: PAGE_HEADING,
});

/* To record the initial HAR file for the story
 * by interacting with the app in the browser.
test.use({
  recordHar: {
    mode: 'minimal',
    path: harFile,
    urlFilter: BASE_API_GLOB
  },
  serviceWorkers: 'block',
  viewport: {
    height: 800,
    width: 600
  }
});
*/

test.describe('@story JIRA-NNNN @JOURNEY page test spec', () => {
  test.beforeEach(shutter.setup);

  test('Entry @content @continue @mockapi', async ({ page }, testInfo) => {
    await page.goto(`${PAGE_URL}#/`);
    await invoke(shutter.screenshot)({
      page,
      counter: 0,
      path: 'entry-content',
      testInfo,
    });

    await expect(
      page.getByRole('heading', { name: PAGE_HEADING }),
    ).toBeVisible();
    await expect(page.getByText('Community').first()).toBeVisible();
    await expect(page.getByTestId('Layout').locator('a')).toBeVisible();
    await expect(page.getByTestId('Layout').locator('a')).toHaveText(
      'Link name',
    );

    await expect(page.getByTestId('next-button')).toBeVisible();
    await expect(page.getByTestId('next-button')).toBeEnabled();
    await page.getByTestId('next-button').click();

    await expect(page.getByTestId('section-area')).toContainText(
      'Section details',
    );
    await expect(
      page.getByTestId('section-area').getByText('Column'),
    ).toBeVisible();
    await expect(page.getByText('Standard').first()).toBeVisible();
    await expect(page.getByText('Standard').nth(1)).toBeVisible();
  });

  // same test suite as above using HAR file instead of mock API
  test('Entry @content @continue @har', async ({ page }, testInfo) => {
    myRouteFromHAR(page, harFile);

    await page.goto(`${PAGE_URL}#/`);
    await invoke(shutter.screenshot)({
      page,
      counter: 1,
      path: 'entry-content-har',
      testInfo,
    });

    await expect(
      page.getByRole('heading', { name: PAGE_HEADING }),
    ).toBeVisible();
    await expect(page.getByText('Community').first()).toBeVisible();
    await expect(page.getByTestId('Layout').locator('a')).toBeVisible();
    await expect(page.getByTestId('Layout').locator('a')).toHaveText(
      'Link name',
    );

    await expect(page.getByTestId('next-button')).toBeVisible();
    await expect(page.getByTestId('next-button')).toBeEnabled();
    await page.getByTestId('next-button').click();

    await expect(page.getByTestId('section-area')).toContainText(
      'Section details',
    );
    await expect(
      page.getByTestId('section-area').getByText('Column'),
    ).toBeVisible();
    await expect(page.getByText('Standard').first()).toBeVisible();
    await expect(page.getByText('Standard').nth(1)).toBeVisible();
  });
});
