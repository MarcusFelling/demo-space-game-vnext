import { test, expect } from '@playwright/test';

test('Download game', async ({ page }) => {
  await page.goto('');

  // Click text=Download game
  await page.locator('text=Download game').click();
  await expect(page).toHaveURL('https://apkflash.com/apk/app/com.mahesa.app.fakegamecollection/fake-game-collection/download');
  await expect(page).toHaveTitle('Download Fake Game Collection APK - Latest Version (Free)');
});
