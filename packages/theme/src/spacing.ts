/**
 * One spacing scale, named rather than multiplied.
 *
 * Steps are named so the same gap is the same token everywhere; a layout that
 * needs a value between two steps wants one of the two steps.
 */
export const Spacing = {
  unit: 4,
  tight: 8,
  snug: 12,
  edge: 16,
  loose: 24,
  section: 32,
} as const;

export const Radius = {
  element: 12,
  card: 16,
  pill: 999,
} as const;

/** Widens the touch target of a control that is smaller than 44pt. */
export const HitSlop = { top: 12, bottom: 12, left: 12, right: 12 } as const;

export type SpacingToken = keyof typeof Spacing;
export type RadiusToken = keyof typeof Radius;
