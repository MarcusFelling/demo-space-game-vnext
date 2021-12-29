import { test } from '@playwright/test';

test('Download game', async ({ page }) => {
  await page.goto('');

  const [ download ] = await Promise.all([
    page.waitForEvent('download'), // wait for download to start
    page.locator('text=Download game').click()
  ]);
  // wait for download to complete
  const path = await download.path();
});
