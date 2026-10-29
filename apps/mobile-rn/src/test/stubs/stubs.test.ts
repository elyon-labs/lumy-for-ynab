import { describe, expect, it } from 'vitest';

import { Platform } from 'react-native';

// Asserts the vitest alias is wired up. Without it a test importing anything
// that reaches `react-native` fails on a Metro-only module, and the failure
// looks like a bug in the module under test rather than in the harness.
describe('the react-native stub', () => {
  it('stands in for the real module', () => {
    expect(Platform.select({ ios: 'yes', default: 'no' })).toBe('yes');
  });
});
