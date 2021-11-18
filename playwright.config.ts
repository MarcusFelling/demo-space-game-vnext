import { PlaywrightTestConfig, devices } from '@playwright/test';
import path from 'path';

// Reference: https://playwright.dev/docs/test-configuration
const config: PlaywrightTestConfig = {
  testDir: 'e2eTests/',
  // Timeout per test
  timeout: 10 * 1000,
  // If a test fails, retry it additional 2 times
  retries: 2,
  // Artifacts folder where screenshots, videos, and traces are stored.
  outputDir: 'test-results/',

  use: {
    // Run headless by default
    headless: true,

    // Use env var to set baseURL
    baseURL: process.env.SITE_URL,

    // Retry a test if its failing with enabled tracing. This allows you to analyse the DOM, console logs, network traffic etc.
    // More information: https://playwright.dev/docs/trace-viewer
    trace: 'retry-with-trace',

    // All available context options: https://playwright.dev/docs/api/class-browser#browser-new-context
    contextOptions: {
      ignoreHTTPSErrors: true,
    },
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
        ...devices['Desktop Firefox'],
      },
    },
    {
      name: 'Desktop Safari',
      use: {
        ...devices['Desktop Safari'],
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
