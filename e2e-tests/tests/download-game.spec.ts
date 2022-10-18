import { test, expect } from '@playwright/test';

test.beforeEach(async ({ page }) => {
  await page.goto('');
});

test('Download game', async ({ page }) => {
  await page.getByText('Download game').click();
  await expect(page).toHaveURL('https://apkcombo.com/fake-game-collection/com.mahesa.app.fakegamecollection/');
  await expect(page).toHaveTitle('Fake Game Collection APK (Android App) - Free Download');
});
