import { test, expect } from '@playwright/test';

test.beforeEach(async ({ page }) => {
  await page.goto('');
});

test('Navigate leadboard', async ({ page }) => {
  // Leaderboard section should have Space leaders header
  await expect(page.locator('section.leaderboard > div > h2')).toHaveText('Space leaders');
  // Click #1 ranked profile
  await page.locator('[data-target="#profile-modal-1"]').click();
  // Make sure profile is ranked #1
  await page.getByText('Rank #1').click();
  // Make sure profile has at least 1 achievement
  const length = await page.$$eval('div.modal-body > div > div.col-sm-8 > div > ul', (items) => items.length);
  expect(length >= 1).toBeTruthy();
  // Close profile modal
  await page.locator('[data-dismiss="modal"] >> nth=0').click();
  // Paginate results
  await page.getByText('2 (current)').click();
  await page.getByText('3 (current)').click();
  await page.getByText('1 (current)').click();

});
