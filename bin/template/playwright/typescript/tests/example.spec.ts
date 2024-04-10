// @ts-check
import { test, expect } from '@playwright/test';

test('has title @example', async ({ page }) => {
  await page.goto('https://playwright.dev/');

  // console.warn(`WARNING`, page);
  // await page.pause(); // for npm run devtools debugging to breakpoint

  // Expect a title "to contain" a substring.
  await expect(page).toHaveTitle(/Playwright/);
});

test('get started link @example', async ({ page }) => {
  await page.goto('https://playwright.dev/');

  // Click the get started link.
  await page.getByRole('link', { name: 'Get started' }).click();

  // Expects page to have a heading with the name of Installation.
  await expect(
    page.getByRole('heading', { name: 'Installation' }),
  ).toBeVisible();
});
