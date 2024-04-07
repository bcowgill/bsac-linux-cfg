// @ts-check
import { test, expect } from "@playwright/test";
import { brand, PAGE_URL } from "./config";
import { getCamera, uiText } from "./lib";
import { J_HOME_TITLE } from "./ui";

// A template test plan for a page in the app, begins by checking the content of
// the entry page in detail.
// then check the links to other pages.
// then user input with warnings or errors.
// then successful user input and going on to other pages.

const suite = "TEMPLATE";

let screenshot;

// define here or import from ui
const PAGE_TITLE = uiText(J_HOME_TITLE);
const PAGE_HEADING = /A heading for your app main page/;
const GET_STARTED_LINK = "start-link";
const TARGET_HEADING = { name: "A new page" };

test.describe("TEMPLATE page test spec", () => {
  test.beforeEach(
    async ({
      page,
      channel,
      browserName,
      defaultBrowserType,
      isMovile,
      viewport,
    }) => {
      if (!screenshot) {
        screenshot = getCamera({
          brand,
          // spec, if we can figure out the test-results dir name corresponding to the current test spec
          suite,
          channel,
          browserName: browserName.toString(),
          defaultBrowserType: defaultBrowserType.toString(),
          isMobile,
          viewport,
        });
      }
      // Go to the starting url before each test.
      await page.goto(PAGE_URL);
      await expect(page).toHaveTitle(PAGE_TITLE);
      await expect(page.getByRole("heading")).toContainText(PAGE_HEADING);
    },
  );

  test("Entry @content", async ({ page }) => {
    // MUSTDO check contents of page is visible
    // MUSTDO check inputs are visible and enabled.
    // MUSTDO check buttons are visible and labels correct.
    // MUSTDO check initial button enabled states.

    // counter numbers can be fixed with fix-counter.sh script if tests are added out of counter order.
    await screenshot({ page, counter: 0, path: "entry-content" });
  });

  test("Entry @links to somewhere", async ({ page }) => {
    await expect(page.getByTestId(GET_STARTED_LINK)).toBeVisible();
    await page.getByTestId(GET_STARTED_LINK).click();
    await expect(page.getByRole("heading", TARGET_HEADING)).toBeVisible();
    await screenshot({ page, counter: 1, path: "entry-link-home" });
  });

  test("Entry @unhappy @action", async ({ page }) => {
    // MUSTDO check user warnings for each input field.
    // MUSTDO check new button enabled state.
    await screenshot({ page, counter: 2, path: "entry-unhappy-fields" });
  });

  test("Entry @unhappy @action @corrected", async ({ page }) => {
    // MUSTDO check user warnings are cleared and corrected and buttons enable/disable as we go.
    await screenshot({
      page,
      counter: 3,
      path: "entry-unhappy-field-corrected",
    });
  });

  test("Entry @happy @action @continue", async ({ page }) => {
    // MUSTDO check user fills in good values and going to the next page.
    await screenshot({ page, counter: 4, path: "entry-happy-continue" });
  });

  test("NEXT PAGE @content", async ({ page }) => {
    // MUSTDO check contents of page is visible
    // MUSTDO check inputs are visible and enabled.
    // MUSTDO check buttons are visible and labels correct.
    // MUSTDO check initial button enabled states.

    await screenshot({ page, counter: 5, path: "NEXTPAGE-content" });
  });
});
