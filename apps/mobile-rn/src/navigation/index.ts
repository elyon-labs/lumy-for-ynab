/**
 * The navigation shell: where someone belongs, and what carries them there.
 *
 * The decision is a pure function in `shellDecision.ts` and the layouts only
 * act on it. That split is what makes the chain testable at all — the app has
 * no renderer in its test setup, so a decision made inside a component is a
 * decision nothing can assert on.
 */
export * from './AuthLinkRouter';
export * from './ErrorScreen';
export * from './linkPath';
export * from './shellDecision';
export * from './Splash';
export * from './useShellDecision';
