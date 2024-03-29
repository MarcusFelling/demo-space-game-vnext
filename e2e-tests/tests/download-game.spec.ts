import { test, expect } from '@playwright/test';

test.beforeEach(async ({ page }) => {
  await page.goto('');
});

test.skip('Download game', async ({ page }) => {
  // Go to download page
  await page.getByRole('link', { name: 'Download game' }).click();
  // Click download button
  await page.getByRole('link', { name: 'Download APK (8 MB)' }).first().click();
  // Wrap download click in promise to wait for download
  const [download] = await Promise.all([
    // Start waiting for the download
    page.waitForEvent('download'),
    // Initiate the download
    page.getByRole('link', { name: 'Fake Game Collection 2.0.21\n(21) APK 8 MB Android 5.0+ nodpi' }).click()
  ]);
  // Save downloaded file
  await download.saveAs('/not/a/real/path/fake.apk');  
});
