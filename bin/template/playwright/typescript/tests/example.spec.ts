// @ts-check
import { test, expect } from '@playwright/test';
import { config } from './config';

test.beforeEach(async ({ page }) => {
  if (config.use?.viewport) {
    page.setViewportSize(config.use.viewport);
  }
});

test('has title @example', async ({ page }) => {
  await page.goto('https://playwright.dev/');

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
