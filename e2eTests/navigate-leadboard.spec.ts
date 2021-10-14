import { test, expect } from '@playwright/test';

test('Navigate leadboard', async ({ page }) => {
  await page.goto('');

  // Leaderboard section should have Space leaders header
  await expect(page.locator('section.leaderboard')).toContainText('Space leaders');
  
  // Click #1 ranked profile
  await page.click('[data-target="#profile-modal-1"]');

  // Make sure profile is ranked #1
  await page.click('text=Rank #1'); 

  // Close modal
  await page.click('[data-dismiss="modal"]');

  // Paginate results
  await page.click('text=2 (current)');
  await page.click('text=3 (current)');
  await page.click('text=1 (current)');

});
