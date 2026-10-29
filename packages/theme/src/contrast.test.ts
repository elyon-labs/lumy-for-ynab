import { describe, expect, it } from 'vitest';

import { contrastRatio, relativeLuminance } from './contrast';

describe('relativeLuminance', () => {
  it('bounds black and white', () => {
    expect(relativeLuminance('#000000')).toBe(0);
    expect(relativeLuminance('#FFFFFF')).toBe(1);
  });

  it('ignores an alpha suffix', () => {
    expect(relativeLuminance('#FFFFFF80')).toBe(relativeLuminance('#FFFFFF'));
  });
});

describe('contrastRatio', () => {
  it('spans 1 to 21', () => {
    expect(contrastRatio('#000000', '#FFFFFF')).toBeCloseTo(21, 5);
    expect(contrastRatio('#FFFFFF', '#FFFFFF')).toBeCloseTo(1, 5);
  });

  it('does not depend on argument order', () => {
    expect(contrastRatio('#5C43D6', '#FFFFFF')).toBeCloseTo(
      contrastRatio('#FFFFFF', '#5C43D6'),
      5,
    );
  });
});
