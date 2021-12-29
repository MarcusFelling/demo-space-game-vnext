import { test, expect } from '@playwright/test';

test('Download game', async ({ page }) => {
  await page.goto('');

  const [ download ] = await Promise.all([
    page.waitForEvent('download'), // wait for download to start
    page.click('text=Download game')
  ]);
  // wait for download to complete
  const path = await download.path();
});
