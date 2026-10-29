import { describe, expect, it } from 'vitest';

import { FontSize, LineHeight } from './typography';

describe('the type scale', () => {
  it('pairs every size with a line height', () => {
    expect(Object.keys(LineHeight).sort()).toEqual(Object.keys(FontSize).sort());
  });

  it('gives every size room to breathe', () => {
    for (const [variant, size] of Object.entries(FontSize)) {
      expect(LineHeight[variant as keyof typeof LineHeight], variant).toBeGreaterThanOrEqual(size);
    }
  });

  it('grows monotonically', () => {
    const sizes = Object.values(FontSize);

    expect([...sizes].sort((a, b) => a - b)).toEqual(sizes);
  });
});
