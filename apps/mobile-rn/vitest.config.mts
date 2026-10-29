import { resolve } from 'node:path';

import { defineConfig } from 'vitest/config';

// .mts so Vite loads this as the ES module it is written as; the app's
// package.json stays CommonJS for metro.config.js and eslint.config.js.
const src = resolve(import.meta.dirname, 'src');

export default defineConfig({
  resolve: {
    // Anchored, so swapping `react-native` cannot also swallow the
    // `react-native-*` packages that only differ by suffix.
    alias: [
      { find: /^@\//, replacement: `${src}/` },
      {
        // react-native cannot be loaded outside a Metro bundle, so the runtime
        // module is swapped while production code keeps the published types.
        find: /^react-native$/,
        replacement: `${src}/test/stubs/react-native.ts`,
      },
    ],
  },
  test: {
    include: ['src/**/*.test.ts'],
  },
});
