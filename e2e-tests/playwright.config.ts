import type { PlaywrightTestConfig } from '@playwright/test';
import { devices } from '@playwright/test';
/**
 * Read environment variables from file for local development.
 * https://github.com/motdotla/dotenv
 */
require('dotenv').config();

// Reference: https://playwright.dev/docs/test-configuration
const config: PlaywrightTestConfig = {
  testDir: 'tests',
  /* Maximum time one test can run for. */
  timeout: 60 * 1000,
  expect: {
    /**
     * Maximum time expect() should wait for the condition to be met.
     * For example in `await expect(locator).toHaveText();`
     */
    timeout: 5000,
  },
  // If a test fails, retry it additional 2 times
  retries: 2,
  /* Reporter to use. See https://playwright.dev/docs/test-reporters */
  reporter: [
    ['junit', { outputFile: './results/junit.xml' }],
    ['html', { outputFolder: './results/html' }],
  ],
  use: {
    // Run headless by default
    headless: true,
    // Use env var to set baseURL
    baseURL: process.env.BASEURL,
    // Retry a test if its failing with enabled tracing. This allows you to analyse the DOM, console logs, network traffic etc.
    // More information: https://playwright.dev/docs/trace-viewer
    trace: 'on',
    // All available context options: https://playwright.dev/docs/api/class-browser#browser-new-context
    contextOptions: {
      ignoreHTTPSErrors: true,
    },

    acceptDownloads: true,
  },
  projects: [
    {
      name: 'Desktop Chrome',
      use: {
        ...devices['Desktop Chrome'],
      },
    },
    {
      name: 'Desktop Edge',
      use: {
        ...devices['Desktop Edge'],
      },
    },
    {
      name: 'Desktop Firefox',
      use: {
        ...devices['Desktop Firefox HiDPI'],
      },
    },
    // Test against mobile viewports.
    {
      name: 'Mobile Chrome',
      use: {
        ...devices['Pixel 5'],
      },
    },
  ],
};
export default config;
