import { test, expect } from '@playwright/test';

test('Navigate leadboard', async ({ page }) => {
  await page.goto('');

  // Leaderboard section should have Space leaders header
  await expect(page.locator('section.leaderboard > div > h2')).toHaveText('Space leaders');
  
  // Click #1 ranked profile
  await page.click('[data-target="#profile-modal-1"]');

  // Make sure profile is ranked #1
  await page.click('text=Rank #1');
  
  // Make sure profile has at least 1 achievement
  const length = await page.$$eval('div.modal-body > div > div.col-sm-8 > div > ul', (items) => items.length);
  expect(length >= 1).toBeTruthy();
  
  // Close profile modal
  await page.click('[data-dismiss="modal"]');

  // Paginate results
  await page.click('text=2 (current)');
  await page.click('text=3 (current)');
  await page.click('text=1 (current)');

});
