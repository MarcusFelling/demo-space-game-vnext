import { test, expect } from '@playwright/test';

test('Download game', async ({ page }) => {
  await page.goto('');
  await page.click('text=Download game');
  await page.click('text=This link is for example purposes and goes nowhere. 😐');
  await page.click('#pretend-modal >> text=×');
});
