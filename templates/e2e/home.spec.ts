import { test, expect } from '@playwright/test';

// --- Basic page load tests ---

test('home page loads and has title', async ({ page }) => {
  await page.goto('/');
  await expect(page).toHaveTitle(/.+/);
});

test('home page renders main content', async ({ page }) => {
  await page.goto('/');
  // Check that body has visible content (not blank page)
  const body = page.locator('main, body');
  await expect(body).toBeVisible();
});

// --- Navigation tests (uncomment when project has nav) ---

// test('navigation links work', async ({ page }) => {
//   await page.goto('/');
//   const navLinks = page.locator('nav a').first();
//   if (await navLinks.isVisible()) {
//     await navLinks.click();
//     await expect(page).toHaveURL(/.+/);
//   }
// });

// --- Form tests (uncomment when project has forms) ---

// test('form submits successfully', async ({ page }) => {
//   await page.goto('/');
//   await page.fill('[name="email"]', 'test@example.com');
//   await page.fill('[name="message"]', 'Test message from E2E');
//   await page.click('button[type="submit"]');
//   // Check success state
//   await expect(page.locator('.success, [data-success]')).toBeVisible({ timeout: 5000 });
// });

// --- Auth tests (uncomment when project has auth) ---

// test('login page works', async ({ page }) => {
//   await page.goto('/login');
//   await page.fill('[name="email"]', 'test@example.com');
//   await page.fill('[name="password"]', 'testpassword');
//   await page.click('button[type="submit"]');
//   await expect(page).toHaveURL(/\/dashboard/);
// });

// --- Responsive tests ---

test('mobile viewport renders correctly', async ({ page }) => {
  await page.setViewportSize({ width: 375, height: 667 });
  await page.goto('/');
  await expect(page.locator('main, body')).toBeVisible();
});

test('desktop viewport renders correctly', async ({ page }) => {
  await page.setViewportSize({ width: 1920, height: 1080 });
  await page.goto('/');
  await expect(page.locator('main, body')).toBeVisible();
});

// --- Accessibility checks ---

test('page has no console errors', async ({ page }) => {
  const errors: string[] = [];
  page.on('console', (msg) => {
    if (msg.type() === 'error') errors.push(msg.text());
  });
  await page.goto('/');
  await page.waitForLoadState('networkidle');
  expect(errors).toHaveLength(0);
});
