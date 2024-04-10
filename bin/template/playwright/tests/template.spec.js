// @ts-check
import { test, expect } from '@playwright/test';
import { brand, PAGE_URL, VIEW, VP_LARGE, VP_MEDIUM, VP_SMALL } from './config';
import { getCamera, uiText } from './lib';
import { J_HOME_TITLE } from './ui';

// A template test plan for a page in the app, begins by checking the content of
// the entry page in detail.
// then check the links to other pages.
// then user input with warnings or errors.
// then successful user input and going on to other pages.

const suite = 'TEMPLATE';

let screenshot;

// define here or import from ui
const PAGE_TITLE = uiText(J_HOME_TITLE);
// const PAGE_HEADING = /A heading for your app main page/;
// const GET_STARTED_LINK = 'start-link';
// const TARGET_HEADING = { name: 'A new page' };
const PAGE_HEADING =
  'Playwright enables reliable end-to-end testing for modern web apps.';
const GET_STARTED_LINK = ['link', { name: 'Get started' }];
const TARGET_HEADING = { name: 'Installation' };

test.describe('TEMPLATE page test spec', () => {
  test.beforeEach(
    async ({ page, channel, browserName, defaultBrowserType, isMobile }) => {
      page.setViewportSize(VIEW);
      if (!screenshot) {
        screenshot = getCamera({
          brand,
          // spec, if we can figure out the test-results dir name corresponding to the current test spec
          suite,
          channel,
          browserName: browserName.toString(),
          defaultBrowserType: defaultBrowserType.toString(),
          isMobile,
          viewport: VIEW,
        });
      }
      // Go to the starting url before each test.
      await page.goto(PAGE_URL);
      await expect(page).toHaveTitle(PAGE_TITLE);
      await expect(page.getByRole('heading').first()).toContainText(
        PAGE_HEADING,
      );
    },
  );

  test('Entry @responsive layout', async ({ page }, testInfo) => {
    // counter numbers can be fixed with fix-counter.sh script if tests are added out of counter order.
    await screenshot({
      page,
      path: 'entry-responsive-small',
      viewport: VP_SMALL,
      fullPage: false,
      testInfo,
    });
    await screenshot({
      page,
      path: 'entry-responsive-medium',
      viewport: VP_MEDIUM,
      fullPage: false,
      testInfo,
    });
    await screenshot({
      page,
      path: 'entry-responsive-large',
      viewport: VP_LARGE,
      fullPage: false,
      testInfo,
    });
  });

  test('Entry @content', async ({ page }, testInfo) => {
    // MUSTDO check contents of page is visible
    // MUSTDO check inputs are visible and enabled.
    // MUSTDO check buttons are visible and labels correct.
    // MUSTDO check initial button enabled states.

    // counter numbers can be fixed with fix-counter.sh script if tests are added out of counter order.
    await screenshot({ page, counter: 0, path: 'entry-content', testInfo });
  });

  test('Entry @links to somewhere', async ({ page }, testInfo) => {
    // await expect(page.getByTestId(GET_STARTED_LINK)).toBeVisible();
    await expect(page.getByRole(...GET_STARTED_LINK)).toBeVisible();
    // await page.getByTestId(GET_STARTED_LINK).click();
    await page.getByRole(...GET_STARTED_LINK).click();
    await expect(page.getByRole('heading', TARGET_HEADING)).toBeVisible();
    await screenshot({ page, counter: 1, path: 'entry-link-home', testInfo });
  });

  test('Entry @unhappy @action', async ({ page }, testInfo) => {
    // MUSTDO check user warnings for each input field.
    // MUSTDO check new button enabled state.
    await screenshot({
      page,
      counter: 2,
      path: 'entry-unhappy-fields',
      testInfo,
    });
  });

  test('Entry @unhappy @action @corrected', async ({ page }, testInfo) => {
    // MUSTDO check user warnings are cleared and corrected and buttons enable/disable as we go.
    await screenshot({
      page,
      counter: 3,
      path: 'entry-unhappy-field-corrected',
      testInfo,
    });
  });

  test('Entry @happy @action @continue', async ({ page }, testInfo) => {
    // MUSTDO check user fills in good values and going to the next page.
    await screenshot({
      page,
      counter: 4,
      path: 'entry-happy-continue',
      testInfo,
    });
  });

  test('NEXT PAGE @content', async ({ page }, testInfo) => {
    // MUSTDO check contents of page is visible
    // MUSTDO check inputs are visible and enabled.
    // MUSTDO check buttons are visible and labels correct.
    // MUSTDO check initial button enabled states.

    await screenshot({ page, counter: 5, path: 'NEXTPAGE-content', testInfo });
  });
});
