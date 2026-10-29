import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    include: ['src/**/*.test.ts'],
    // Each test opens its own in-memory database, so they do not contend.
    pool: 'threads',
  },
});
