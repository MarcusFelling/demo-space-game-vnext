import { test, expect } from '@playwright/test';

test('View game screenshot examples', async ({ page }) => {
  await page.goto('');
  
  // Loop through each game screenshot example
  for (const screenshot of ['screenshot-1', 'screenshot-2', 'screenshot-3', 'screenshot-4']) {
    
    // Click each screenshot example using data-test-id
    await page.click("data-test-id=" + screenshot);
    
    // Close screenshot
    await page.click('text=× Gamescreen example >> button'); 
  }
});
