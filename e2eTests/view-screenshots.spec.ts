import { test, expect } from '@playwright/test';

test('View Screenshot examples', async ({ page }) => {
  await page.goto('');
  await page.click('li img');
  await page.click('text=× Gamescreen example >> button');
  await page.click('ul >> :nth-match(img, 2)');
  await page.click('text=× Gamescreen example >> button');
});
