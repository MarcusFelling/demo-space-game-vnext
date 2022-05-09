import { test, expect } from '@playwright/test';

test('Download game', async ({ page }) => {
  await page.goto('https://spacegamevnext-test.azurewebsites.net/');

  // Click text=Download game
  await page.locator('text=Download game').click();
  await expect(page).toHaveURL('https://apkcombo.com/fake-game-collection/com.mahesa.app.fakegamecollection/');
  await expect(page).toHaveTitle('Download Fake Game Collection APK - Latest Version (Free)');
});
